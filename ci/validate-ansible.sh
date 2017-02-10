#!/usr/bin/env bash

set -euf -o pipefail

test -n "${PACKER_ANSIBLE_INVENTORY_GROUPS}" || (
    echo "PACKER_ANSIBLE_INVENTORY_GROUPS must be set or ansible will fail!"
    exit 1
)
ansible-playbook --syntax-check "${PACKER_ANSIBLE_DIR}/site.yml"
