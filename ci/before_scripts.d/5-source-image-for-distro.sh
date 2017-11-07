if [[ ${!DISTRO[@]} ]]; then
  source_image_var="OS_SOURCE_IMAGE_${DISTRO}"
  export OS_SOURCE_IMAGE="${!source_image_var}"
  image_source_url_var="IMAGE_SOURCE_URL_${DISTRO}"
  if [[ -n ${!image_source_url_var+x} ]]; then
    export IMAGE_SOURCE_URL="${!image_source_url_var}"
  fi
  packer_source_image_username_var="PACKER_SOURCE_IMAGE_USERNAME_${DISTRO}"
  export PACKER_SOURCE_IMAGE_USERNAME="${!packer_source_image_username_var}"
fi
