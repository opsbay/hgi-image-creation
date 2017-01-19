#!/bin/bash

set -euf -o pipefail

repos_dir=$1
clone_dir=$2

echo "clone-repos.sh will clone all repos specified in ${repos_dir} into subdirectories of ${clone_dir}"

mkdir -p ${clone_dir}
cd ${clone_dir}

for repo_file in ${repos_dir}/*.giturl; do 
    repo_name="$(basename ${repo_file} .giturl)"
    repo_url="$(cat ${repo_file})"
    git clone "${repo_url}" "${repo_name}"
    cd "${repo_name}"
    git describe --tags --dirty --always
done
