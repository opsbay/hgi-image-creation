#!/usr/bin/env bash

set -eu -o pipefail

test -n "${PACKER_IMAGE_NAME}" || (
    echo "PACKER_IMAGE_NAME not specified!"
    exit 1
)
test -n "${DEPLOY_IMAGE_NAME}" || (
    echo "DEPLOY_IMAGE_NAME not specified!"
    exit 1
)
glancecp --duplicate-name-strategy=replace --dest-os-tenant-name="${DEPLOY_TENANT}" "${PACKER_IMAGE_NAME}" "DEPLOY:${DEPLOY_IMAGE_NAME}"