if [[ ${!DISTRO[@]} ]]; then
  source_image_var="OS_SOURCE_IMAGE_${DISTRO}"
  export OS_SOURCE_IMAGE="${!source_image_var}"
  echo "OS_SOURCE_IMAGE now set to '${OS_SOURCE_IMAGE}' for distro ${DISTRO}"
  image_source_url_var="IMAGE_SOURCE_URL_${DISTRO}"
  if [[ -n ${!image_source_url_var+x} ]]; then
    export IMAGE_SOURCE_URL="${!image_source_url_var}"
    echo "IMAGE_SOURCE_URL now set to '${IMAGE_SOURCE_URL}' for distro ${DISTRO}"
  fi
  packer_source_image_username_var="PACKER_SOURCE_IMAGE_USERNAME_${DISTRO}"
  export PACKER_SOURCE_IMAGE_USERNAME="${!packer_source_image_username_var}"
  echo "PACKER_SOURCE_IMAGE_USERNAME now set to '${PACKER_SOURCE_IMAGE_USERNAME}' for distro ${DISTRO}"
else
  echo "DISTRO not set, no distro specific variables have been set"
fi
