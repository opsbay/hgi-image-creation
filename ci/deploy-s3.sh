#!/usr/bin/env bash

set -eu -o pipefail

# Save OpenStack image to disk
glance image-download --file --progress "./${DEPLOY_IMAGE_NAME}.img" "${DEPLOY_IMAGE_NAME}"

# Upload OpenStack imge to S3
s3cmd put \
        --access_key="${S3_ACCESS_KEY}" \
        --secret_key="${S3_SECRET_KEY}" \
        --check-md5 \
        --ssl \
        --progress \
        --host="${S3_HOST}" \
        --host-bucket="${S3_HOST_BUCKET}" \
    "./${DEPLOY_IMAGE_NAME}.img" "s3://${S3_IMAGE_BUCKET}"
