#!/usr/bin/env bash

# set defaults
export HGI_IMAGE_CREATION_DIR="./"
export IMAGE_CREATION_DIR="./subrepos/image-creation"

#export PACKER_DIR="${HGI_IMAGE_CREATION_DIR}/packer"

export OS_SOURCE_IMAGE_xenial="Ubuntu Xenial"
#export PACKER_OS_SOURCE_IMAGE="	Ubuntu 16.04 Xenial"

export KITCHEN_YAML="${IMAGE_CREATION_DIR}/.kitchen.yml"
export KITCHEN_PROVISIONER_SCRIPT="${IMAGE_CREATION_DIR}/bootstrap.sh"
