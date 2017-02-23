#!/bin/bash

set -euf -o pipefail

branch=$1
commit_message=$2
tfstate_paths=$3

git pull
git config user.name "Mercury"
git config user.email "mercury@sanger.ac.uk"
git checkout -b ${branch}
git add "${tfstate_paths}"

status=$(git status --porcelain | awk '$1!="??"')

if [ -n "${status}" ]; then
    git commit -m "${commit_message}" || (echo "Failed to commit changes to ${tfstate_paths}" && exit 1)
    echo "Pushing to ${GITHUB_REPO}..."
    subrepos/gitlab-ci-git-push/git-push ${GITHUB_REPO} ${CI_BUILD_REF_NAME} || (echo "Failed to push to github" && exit 1)
    echo "Pushing to ${GITLAB_REPO}..."
    subrepos/gitlab-ci-git-push/git-push ${GITLAB_REPO} ${CI_BUILD_REF_NAME} || (echo "Failed to push to gitlab" && exit 1)
else
    echo "No changes to terraform state"
fi

