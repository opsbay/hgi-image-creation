#!/usr/bin/env bash

set -eu -o pipefail

# TODO: The ruby script is going to move to GITLAB_HGI_CI_DIR
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $(dirname "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}")
"${SCRIPT_DIRECTORY}/prepare-os-source-image.rb" "${OS_SOURCE_IMAGE}" "${S3_IMAGE_BUCKET}" > "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
