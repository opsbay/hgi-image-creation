if [[ -z "${TERRAFORM_CONSUL_TOKEN+x}" ]]; then
    >&2 echo "TERRAFORM_CONSUL_TOKEN must be set!"
    exit 1
fi

export CONSUL_HTTP_TOKEN=${TERRAFORM_CONSUL_TOKEN}
