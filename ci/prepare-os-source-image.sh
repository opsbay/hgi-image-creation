#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p $(dirname "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}")

"${HGI_IMAGE_CREATION_DIR}/subrepos/hgi-systems/ci/prepare-os-image.rb" "${OS_SOURCE_IMAGE}" "${S3_IMAGE_BUCKET}" \
    > "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
