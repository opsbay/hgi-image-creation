#!/usr/bin/env bash

set -eu -o pipefail

packer build ${PACKER_DEBUG} -only=openstack "${PACKER_DIR}/template-${DISTRO}.json" || (
    echo "Packer ${DISTRO} build failed, removing image '${PACKER_IMAGE_NAME}'"
    "${PACKER_DIR}/scripts/remove_failed_builds.py" --image_name="${PACKER_IMAGE_NAME}"
    exit 1
)
