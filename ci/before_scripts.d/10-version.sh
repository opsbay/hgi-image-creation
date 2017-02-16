#!/bin/bash

#set -euf -o pipefail
set +e
set +u

eval export OS_SOURCE_IMAGE="\${OS_SOURCE_IMAGE_${DISTRO}}"
export VERSION=$(${VERSION_COMMAND})
if [[ $? -ne 0 ]]; then
    echo "VERSION_COMMAND exited with error $?"
    exit $?
fi

if [[ -z "${VERSION}" ]]; then
    echo "VERSION_COMMAND \"${VERSION_COMMAND}\" returned empty version string"
    exit 1
fi


if [[ -n "${IMAGE_BASENAME}" ]]; then
    if [[ -n "${DISTRO}" ]]; then
        if [[ -n "${VERSION}" ]]; then
            export PACKER_IMAGE_NAME="${IMAGE_BASENAME}-${DISTRO}-${VERSION}"
            echo "Set PACKER_IMAGE_NAME to ${PACKER_IMAGE_NAME}"
        else
            echo "Not setting PACKER_IMAGE_NAME because VERSION is empty"
        fi
    else
        echo "Not setting PACKER_IMAGE_NAME because DISTRO is empty"
    fi
else
    echo "Not setting PACKER_IMAGE_NAME because IMAGE_BASENAME is empty"
fi
export DEPLOY_IMAGE_NAME="${PACKER_IMAGE_NAME}"
export DEPLOY_IMAGE_NAME_LATEST="${IMAGE_BASENAME}-${DISTRO}-${LATEST_VERSION_PLACEHOLDER}"
eval export PACKER_SOURCE_IMAGE_USERNAME="\${PACKER_SOURCE_IMAGE_USERNAME_${DISTRO}}"

if [[ -r "${OS_SOURCE_IMAGE_ARTIFACT}" ]]; then
    export PACKER_OS_SOURCE_IMAGE="$(cat ${OS_SOURCE_IMAGE_ARTIFACT})"
    echo "Set PACKER_OS_SOURCE_IMAGE=${PACKER_OS_SOURCE_IMAGE} from ${OS_SOURCE_IMAGE_ARTIFACT} artifact."
else
    echo "No readable OS_SOURCE_IMAGE_ARTIFACT (${OS_SOURCE_IMAGE_ARTIFACT})"
fi

if [[ -r "${OS_NETWORKS_ARTIFACT}" ]]; then
    export PACKER_OS_NETWORKS="$(cat ${OS_NETWORKS_ARTIFACT})"
    echo "Set PACKER_OS_NETWORKS=${PACKER_OS_NETWORKS} from ${OS_NETWORKS_ARTIFACT} artifact."
else
    echo "No readable OS_NETWORKS_ARTIFACT (${OS_NETWORKS_ARTIFACT})"
fi
