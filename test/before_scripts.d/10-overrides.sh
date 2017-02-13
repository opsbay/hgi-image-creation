#!/usr/bin/env bash

# set defaults
export HGI_IMAGE_CREATION_DIR="./"
export IMAGE_CREATION_DIR="./subrepos/image-creation"

export PACKER_DIR="${HGI_IMAGE_CREATION_DIR}/packer"

export KITCHEN_YAML="${IMAGE_CREATION_DIR}/.kitchen.yml"
export KITCHEN_PROVISIONER_SCRIPT="${IMAGE_CREATION_DIR}/bootstrap.sh"
