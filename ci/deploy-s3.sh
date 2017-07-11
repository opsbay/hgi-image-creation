#!/usr/bin/env bash

set -euf -o pipefail

echo ""
# Stream OpenStack image to stdout and pipe it both into md5sum and minio client for upload to S3
(openstack image save "${PACKER_IMAGE_NAME}" | tee /dev/fd/4 | mc pipe deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME}) 4>&1 | md5sum - > "${DEPLOY_IMAGE_NAME}.md5"

echo "Uploaded ${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} with md5:"
cat "${DEPLOY_IMAGE_NAME}.md5"

# fetch data back from s3 and check md5
mc cat deploy/${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME} | md5sum -c "${DEPLOY_IMAGE_NAME}.md5" -

echo "Uploaded ${DEPLOY_IMAGE_NAME} to ${S3_IMAGE_BUCKET} with md5: $(cat ${DEPLOY_IMAGE_NAME}.md5)"
