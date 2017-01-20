#!/bin/bash

set -euf -o pipefail

repos_dir=$1
clone_dir=$2
versions_file=$3

echo "clone-repos.sh will clone all repos specified in ${repos_dir} into subdirectories of ${clone_dir}"

mkdir -p "${clone_dir}"
for repo_file in $(find "${repos_dir}" -maxdepth 1 -name \*.giturl); do
    (
        repo_name="$(basename ${repo_file} .giturl)"
        repo_url="$(cat ${repo_file})"
        cd "${clone_dir}"
        echo "cloning from URL: ${repo_url}"
        git clone "${repo_url}" "${repo_name}"
        cd "${repo_name}"
        repo_version="${repo_name}-$(git describe --tags --dirty --always)"
        echo "Adding ${repo_version} to ${versions_file}"
        echo -n "-${repo_version}" >> "${versions_file}"
        echo "cloned ${repo_version}"
    )
done
