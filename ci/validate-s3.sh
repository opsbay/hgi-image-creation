#!/usr/bin/env bash

set -euf -o pipefail

if [ ! -f "~/.s3cfg" ]; then
    >&2 echo ".s3cfg must be written!"
    exit 1
fi
if [ -z "${S3_IMAGE_BUCKET+x}" ]; then
    >&2 echo "S3_IMAGE_BUCKET must be set!"
    exit 1
fi

existingImage=$(s3cmd ls "s3://${S3_IMAGE_BUCKET}/${DEPLOY_IMAGE_NAME}") || (
    >&2 echo "Could not connect to object store: exit code $?"
    exit 1
)

if [ -n "${existingImage}" ]; then
    >&2 echo "An image named '${DEPLOY_IMAGE_NAME}' already exists in the object store, refusing to continue!"
    exit 1
fi
