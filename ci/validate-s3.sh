#!/usr/bin/env bash

set -euf -o pipefail

# validate s3cmd config
if [ ! -f "${HOME}/.s3cfg" ]; then
    >&2 echo "${HOME}/.s3cfg must be written!"
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

# validate minio client config
if [ ! -f "${HOME}/.mc/config.json" ]; then
    >&2 echo "${HOME}/.mc/config.json must exist!"
    exit 1
fi

deploy_host_access=$(mc config host list | awk '$1=="deploy:" {print $2, $3}')
if [ -z "${deploy_host_access}" ]; then
    >&2 echo "mc config has no entry for deploy"
    exit 1
fi

echo "validate-s3.sh: mc config deploy entry using ${deploy_host_access}"
