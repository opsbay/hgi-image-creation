#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p $(dirname "${GITLAB_OS_NETWORKS_ARTIFACT}")

for network in "$(echo "${OS_NETWORKS}" | tr "," "\n")"; do
    openstack network show -c id -f value "${network}"
done | paste -s -d "," > "${GITLAB_OS_NETWORKS_ARTIFACT}"
