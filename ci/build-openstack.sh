#!/usr/bin/env bash

set -eu -o pipefail

ensureSet OS_AUTH_URL OS_USERNAME OS_PASSWORD OS_TENANT_NAME MINIO_ENDPOINT MINIO_ACCESS_KEY_ID MINIO_SECRET_ACCESS_KEY PACKER_IMAGE_NAME S3_IMAGE_BUCKET DEPLOY_IMAGE_NAME

echo "Build openstack running packer build with: "
echo "PACKER_IMAGE_NAME: ${PACKER_IMAGE_NAME}"
echo "PACKER_OS_SOURCE_IMAGE: ${PACKER_OS_SOURCE_IMAGE}"
echo "PACKER_OS_NETWORKS: ${PACKER_OS_NETWORKS}"
echo "PACKER_SOURCE_IMAGE_USERNAME: ${PACKER_SOURCE_IMAGE_USERNAME}"
echo "PACKER_OS_SECURITY_GROUPS: ${PACKER_OS_SECURITY_GROUPS}"
echo "PACKER_OS_FLAVOR: ${PACKER_OS_FLAVOR}"
echo "PACKER_OS_FLOATING_IP_POOL: ${PACKER_OS_FLOATING_IP_POOL}"
echo "PACKER_CLOUD_INIT_WAIT_TIMEOUT_S: ${PACKER_CLOUD_INIT_WAIT_TIMEOUT_S}"
echo "PACKER_ANSIBLE_DIR: ${PACKER_ANSIBLE_DIR}"
echo "PACKER_ANSIBLE_INVENTORY_GROUPS: ${PACKER_ANSIBLE_INVENTORY_GROUPS}"

packer build ${PACKER_DEBUG} -only=openstack "${PACKER_DIR}/template-${DISTRO}.json" || (
    echo "Packer ${DISTRO} build failed, removing image '${PACKER_IMAGE_NAME}'"
    "${PACKER_DIR}/scripts/remove_failed_builds.py" --image_name="${PACKER_IMAGE_NAME}"
    exit 1
)

# Create temp dir
temp_dir=$(mktemp -d)
echo "Created temp_dir ${temp_dir} to save qcow2 image"

# Start glance proxy to download raw snapshot image from Glance into S3 and then make partial downloads available on localhost:8080
echo "Starting glance-proxy to fetch snapshot from openstack"
glance-proxy -minio-bucket hgi-openstack-images -minio-prefix tmp -log-level info &> ${temp_dir}/glance-proxy.log &
glance_proxy_pid=$(echo $!)
local_image_url="http://127.0.0.1:8080/name/${PACKER_IMAGE_NAME}"

# Prefetch image in glance_proxy to ensure it is ready for qemu-img convert
echo -n "Sending http HEAD to prefetch ${local_image_url} into S3 and checking it is ready..."
ready=0
while [[ "${ready}" -eq 0 ]]; do
    curl -s --head "${local_image_url}" && ready=1 || (echo -n "."; sleep 1)
done
echo "done!"

# Convert raw image served by glance-proxy to qcow2 saved in local temp dir
echo "Calling qemu-img convert to fetch raw image from glance-proxy and convert to qcow2 locally"
qemu-img convert -O qcow2 --image-opts "driver=http,timeout=900,url=${local_image_url}" "${temp_dir}/${PACKER_IMAGE_NAME}.qcow2" || (echo "qemu-img failed, glance-proxy logs were:"; cat ${temp_dir}/glance-proxy.log; exit 1)

# Stream image to stdout and pipe it both into md5sum and minio client for upload to S3
upload_md5=$((cat "${temp_dir}/${PACKER_IMAGE_NAME}.qcow2" | tee /dev/fd/4 | mc pipe deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} 1>&2 ) 4>&1 | md5sum - )

echo "Uploaded qcow2 image ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} to S3 with md5: ${upload_md5}"

# fetch qcow2 data back from s3 and check md5
echo "Fetching qcow2 image ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} from S3 and creating in openstack"
check_md5=$(mc cat deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} | md5sum - )
echo "Fetched qcow2 image ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5: ${check_md5}"

echo "Asking glance proxy to delete temporary files"
curl -X DELETE "${local_image_url}"

echo "Killing glance-proxy process ${glance_proxy_pid}"
kill ${glance_proxy_pid}

echo "Glance proxy logs were:"
cat "${temp_dir}/glance-proxy.log"

echo "Removing temp_dir ${temp_dir}"
rm -rf "${temp_dir}"

if [[ "${upload_md5}" == "${check_md5}" ]]; then
    echo "MD5 match, deleting raw packer snapshot ${PACKER_IMAGE_NAME} from openstack"
    openstack image delete ${PACKER_IMAGE_NAME}
else
    echo "MD5 mismatch, leaving image ${PACKER_IMAGE_NAME} in place"
    exit 1
fi

echo "Creating openstack QCOW2 image from S3"
openstack image create --disk-format qcow2 --file <(mc cat deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME}) -c id -f value "${PACKER_IMAGE_NAME}"
echo "Done!"

exit 0
