#!/usr/bin/env bash

# TODO: The ruby script is going to move to GITLAB_HGI_CI_DIR
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"${SCRIPT_DIRECTORY}/prepare-os-source-image.rb" "${OS_SOURCE_IMAGE}" "${S3_IMAGE_BUCKET}" > "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
