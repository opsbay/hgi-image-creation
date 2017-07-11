#!/usr/bin/env bash

set -euf -o pipefail

# validate mc (minio client) config
if [ ! -f "${HOME}/.mc/config.json" ]; then
    >&2 echo "${HOME}/.mc/config.json must exist!"
    exit 1
fi

deploy_host_access=$(mc config host list | awk '$1=="deploy:" {print $2, $3}')
if [ -z "${deploy_host_access}" ]; then
    >&2 echo "mc config has no entry for deploy"
    exit 1
fi
