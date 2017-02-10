#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p $(dirname "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}")
openstack image show -c id -f value "${OS_SOURCE_IMAGE}" > "${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
