if [ "${CI_BUILD_STAGE}" == "deploy" ]; then
    export OS_AUTH_URL="$(echo ${DEPLOY_OS_AUTH_URL} | sed 's/[\r\n]//g')"
    export OS_USERNAME="$(echo ${DEPLOY_OS_USERNAME} | sed 's/[\r\n]//g')"
    export OS_PASSWORD="$(echo ${DEPLOY_OS_PASSWORD} | sed 's/[\r\n]//g')"
else
    export OS_AUTH_URL="$(echo ${PACKER_OS_AUTH_URL} | sed 's/[\r\n]//g')"
    export OS_TENANT_NAME="$(echo ${PACKER_OS_TENANT_NAME} | sed 's/[\r\n]/)/g')"
    export OS_USERNAME="$(echo ${PACKER_OS_USERNAME} | sed 's/[\r\n]//g')"
    export OS_PASSWORD="$(echo ${PACKER_OS_PASSWORD} | sed 's/[\r\n]//g')"
    export OS_NETWORKS="$(echo ${PACKER_OS_NETWORKS} | sed 's/[\r\n]//g')"
fi

