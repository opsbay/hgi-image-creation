#!/bin/bash

set -euf -o pipefail

test -d "${PACKER_DIR}" || (echo "Directory ${PACKER_DIR} must exist!"; exit 1)
test -n "${OS_AUTH_URL}" || (echo "OS_AUTH_URL must be set!"; exit 1)
test -n "${OS_TENANT_NAME}" || test -n "${OS_TENANT_ID}" || (echo "OS_TENANT_NAME or OS_TENANT_ID must be set!"; exit 1)
test -n "${OS_USERNAME}" || test -n "${OS_USERID}" || (echo "OS_USERNAME or OS_USERID must be set!"; exit 1)
test -n "${OS_PASSWORD}" || (echo "OS_PASSWORD must be set!"; exit 1)
((echo "${OS_AUTH_URL}" | grep -q "v3") && (test -n "${OS_DOMAIN_NAME}" || test -n "${OS_DOMAIN_ID}" || echo "WARNING: OS_DOMAIN_ID or OS_DOMAIN_NAME not set, v3 auth may fail")) || true
image_id=$(openstack image show -c name -c id -f table  "${PACKER_IMAGE_NAME}" || echo -n "") && test -z "${image_id}" && echo "There is no existing image called '${PACKER_IMAGE_NAME}' (ok!)" || (echo "An image named '${PACKER_IMAGE_NAME}' already exists, refusing to continue!" && exit 1)
openstack image show -c name -c id -f table "${PACKER_OS_SOURCE_IMAGE}"
for network_id in "$(echo "${PACKER_OS_NETWORKS}" | tr "," "\n")"; do openstack network show -c name -c id -f table "${network_id}"; done
test -n "${PACKER_SOURCE_IMAGE_USERNAME}"
for secgroup in "${PACKER_OS_SECURITY_GROUPS}"; do openstack security group show -c name -c id -f table "${secgroup}"; done
openstack flavor show -c name -c id -f table "${PACKER_OS_FLAVOR}"
openstack ip floating pool list -f value | grep "${PACKER_OS_FLOATING_IP_POOL}"
test "${PACKER_CLOUD_INIT_WAIT_TIMEOUT_S}" -gt 0

packer validate -only=openstack "${PACKER_DIR}/template-xenial.json"
