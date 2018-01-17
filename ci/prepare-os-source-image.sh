#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p $(dirname "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}")

if [[ ! ${!IMAGE_SOURCE_URL[@]} ]]; then
    export IMAGE_SOURCE_URL=""
fi

echo "Preparing OS_SOURCE_IMAGE ${OS_SOURCE_IMAGE} from ${IMAGE_SOURCE_URL} into S3 bucket ${S3_IMAGE_BUCKET}"
"./subrepos/hgi-systems/ci/prepare-os-image.rb" \
    "${OS_SOURCE_IMAGE}" \
    "${S3_IMAGE_BUCKET}" \
    "${IMAGE_SOURCE_URL}" \
    > "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
echo "Image prepared as $(cat ${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}) and saved to artifact ${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
