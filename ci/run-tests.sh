#!/usr/bin/env bash
set -eu -o pipefail

if [ ! -f ".gitlab-ci.yml" ]
then
    >&2 echo "Must be ran in the image builder's root directory"
    exit 1
fi

export OS_SECURITY_GROUPS="${KITCHEN_OS_SECURITY_GROUPS}"
export OS_NETWORKS="${KITCHEN_OS_NETWORKS}"
export MODE="${KITCHEN_MODE}"
export DEBUG="${KITCHEN_DEBUG}"
export KITCHEN_YAML="${KITCHEN_YAML}"
export PROVISIONER_SCRIPT="${KITCHEN_PROVISIONER_SCRIPT}"

export IMAGE_NAME="${PACKER_OS_SOURCE_IMAGE}"
export OS_BASE_IMAGE="${PACKER_OS_SOURCE_IMAGE}"
export IMAGE_USERNAME="${PACKER_SOURCE_IMAGE_USERNAME}"
export PLATFORM="ubuntu-16.04"  # This refers to the platform on which kitchen will be ran
export KEYPAIR=$( (echo -n ${PLATFORM} ; echo -n "${MODE}" ; date +%s-%N) | md5sum | cut -d " " -f 1 )
export http_proxy=""
export http_proxys=""

"${IMAGE_CREATION_DIR}/kitchen_wrapper.sh"