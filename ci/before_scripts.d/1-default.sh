#!/bin/bash

# set defaults
export PACKER_ANSIBLE_INVENTORY_GROUPS="" # ansible groups to place the build in for provisioning
export IMAGE_BASENAME="${CI_PROJECT_NAME}"

export OS_SOURCE_IMAGE_xenial="Ubuntu Xenial" # name or id of openstack xenial image
export PACKER_SOURCE_IMAGE_USERNAME_xenial="ubuntu"
export OS_SOURCE_IMAGE_trusty="Ubuntu Trusty" # name or id of openstack trusty image
export PACKER_SOURCE_IMAGE_USERNAME_trusty="ubuntu"

export OS_NETWORKS="hgiarvados" # comma-separated

export VERSION_ABBREV_LEN="8"
export VERSION_COMMAND="git describe --tags --dirty --always --abbrev=${VERSION_ABBREV_LEN}"
export LATEST_VERSION_PLACEHOLDER="latest"

export PACKER_OS_FLAVOR="m1.small"
export PACKER_OS_FLOATING_IP_POOL="nova"
export PACKER_OS_SECURITY_GROUPS="ssh_hgiarvados" # comma-separated
export PACKER_CLOUD_INIT_WAIT_TIMEOUT_S="180"
export PACKER_LOG="0" # "0" for normal logging or "1" for extra logging
export PACKER_DEBUG="" # "" for normal, "-debug" for debug

export HGI_IMAGE_CREATION_DIR="./subrepos/hgi-image-creation"
export PACKER_DIR="${HGI_IMAGE_CREATION_DIR}/packer"
export PACKER_ANSIBLE_DIR="./subrepos/hgi-systems/ansible"

export ARTIFACTS_DIR="${GITLAB_ARTIFACTS_DIR}"
export OS_SOURCE_IMAGE_ARTIFACT="${GITLAB_OS_SOURCE_IMAGE_ARTIFACT}"
export OS_NETWORKS_ARTIFACT="${GITLAB_OS_NETWORKS_ARTIFACT}"

