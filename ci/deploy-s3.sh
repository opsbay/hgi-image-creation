#!/usr/bin/env bash

set -euf -o pipefail

echo ""
# Stream OpenStack image to stdout and pipe it both into md5sum and minio client for upload to S3
upload_md5=$((openstack image save "${PACKER_IMAGE_NAME}" | tee /dev/fd/4 | mc pipe deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} 1>&2 ) 4>&1 | md5sum - )

echo "Uploaded ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5: ${upload_md5}"

# fetch data back from s3 and check md5
check_md5=$(mc cat deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} | md5sum - )

echo "Fetched ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5: ${check_md5}"

if [[ "${upload_md5}" == "${check_md5}" ]]; then
    echo "MD5 match"
else
    echo "MD5 mismatch"
    exit 1
fi

exit 0
