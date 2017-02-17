#!/usr/bin/env bash

set -euf -o pipefail

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "${SCRIPT_DIRECTORY}/_common.sh"

echo $(getS3ImageName "test")

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

imageFileName="$(getS3ImageFileName "${DEPLOY_IMAGE_NAME}")"
existingImage= $(s3cmd ls \
        --access_key="${S3_ACCESS_KEY}" \
        --secret_key="${S3_SECRET_KEY}" \
        --ssl \
        --host="${S3_HOST}" \
        --host-bucket="${S3_HOST_BUCKET}" \
    "s3://${S3_IMAGE_BUCKET}/${imageFileName}")

if [ -n "${existingImage}" ]; then
    >&2 echo "An image named '${imageFileName}' already exists in the object store, refusing to continue!"
    exit 1
fi
