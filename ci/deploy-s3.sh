#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIRECTORY}/common.sh"

set -euf -o pipefail

ensureSet OS_AUTH_URL OS_USERNAME OS_PASSWORD OS_TENANT_NAME MINIO_ENDPOINT MINIO_ACCESS_KEY_ID MINIO_SECRET_ACCESS_KEY PACKER_IMAGE_NAME S3_IMAGE_BUCKET DEPLOY_IMAGE_NAME

echo ""

# Create temp dir
temp_dir=$(mktemp -d)
echo "Created temp_dir ${temp_dir} to save qcow2 image"

# Start glance proxy to download raw snapshot image from Glance into S3 and then make partial downloads available on localhost:8080
echo "Starting glance-proxy"
glance-proxy -minio-bucket hgi-openstack-images -minio-prefix tmp &> ${temp_dir}/glance-proxy.log
glance_proxy_pid=$(echo $!)
local_image_url="http://127.0.0.1:8080/name/${PACKER_IMAGE_NAME}"

# Convert raw image served by glance-proxy to qcow2 saved in local temp dir
qemu-img convert -O qcow2 --image-opts "driver=http,timeout=900,url=${local_image_url}" "${temp_dir}/${PACKER_IMAGE_NAME}.qcow2" || (echo "qemu-img failed, glance-proxy logs were:"; cat ${temp_dir}/glance-proxy.log; exit 1)

# Stream image to stdout and pipe it both into md5sum and minio client for upload to S3
upload_md5=$((cat "${temp_dir}/${PACKER_IMAGE_NAME}.qcow2" | tee /dev/fd/4 | mc pipe deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} 1>&2 ) 4>&1 | md5sum - )

echo "Uploaded qcow2 image ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5: ${upload_md5}"

# fetch data back from s3 and check md5
check_md5=$(mc cat deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} | md5sum - )

echo "Fetched qcow2 image ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5: ${check_md5}"

echo "Asking glance proxy to delete temporary file"
curl -X DELETE "${local_image_url}"

echo "Killing glance-proxy process ${glance_proxy_pid}"
kill ${glance_proxy_pid}

echo "Removing temp_dir ${temp_dir}"
rm -rf "${temp_dir}"

if [[ "${upload_md5}" == "${check_md5}" ]]; then
    echo "MD5 match, deleting raw packer snapshot ${PACKER_IMAGE_NAME} from openstack"
    openstack image delete ${PACKER_IMAGE_NAME}
else
    echo "MD5 mismatch"
    exit 1
fi

exit 0
