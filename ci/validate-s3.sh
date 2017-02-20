#!/usr/bin/env bash

set -euf -o pipefail

if [ -z "${S3_ACCESS_KEY+x}" ]; then
    >&2 echo "S3_ACCESS_KEY must be set!"
    exit 1
fi
if [ -z "${S3_SECRET_KEY+x}" ]; then
    >&2 echo "S3_SECRET_KEY must be set!"
    exit 1
fi
if [ -z "${S3_HOST+x}" ]; then
    >&2 echo "S3_HOST must be set!"
    exit 1
fi
if [ -z "${S3_HOST_BUCKET+x}" ]; then
    >&2 echo "S3_HOST_BUCKET must be set!"
    exit 1
fi
if [ -z "${S3_IMAGE_BUCKET+x}" ]; then
    >&2 echo "S3_IMAGE_BUCKET must be set!"
    exit 1
fi

existingImage=$(
    s3cmd ls \
        --access_key="${S3_ACCESS_KEY}" \
        --secret_key="${S3_SECRET_KEY}" \
        --ssl \
        --host="${S3_HOST}" \
        --host-bucket="${S3_HOST_BUCKET}" \
    "s3://${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME}"
) || (
    >&2 echo "Could not connect to object store: exit code $?"
    exit 1
)

if [ -n "${existingImage}" ]; then
    >&2 echo "An image named '${DEPLOY_IMAGE_NAME}' already exists in the object store, refusing to continue!"
    exit 1
fi
