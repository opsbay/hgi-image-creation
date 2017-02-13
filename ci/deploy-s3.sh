#!/usr/bin/env bash

set -euf -o pipefail

IMAGE_FILE_LOCATION="${DEPLOY_IMAGE_NAME}.img"

# Save OpenStack image to disk
glance image-download --file "${IMAGE_FILE_LOCATION}" --progress "${DEPLOY_IMAGE_NAME}"

# Upload OpenStack image to S3
s3cmd put \
        --access_key="${S3_ACCESS_KEY}" \
        --secret_key="${S3_SECRET_KEY}" \
        --check-md5 \
        --ssl \
        --progress \
        --host="${S3_HOST}" \
        --host-bucket="${S3_HOST_BUCKET}" \
    "${IMAGE_FILE_LOCATION}" "s3://${S3_IMAGE_BUCKET}"
