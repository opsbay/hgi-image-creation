#!/usr/bin/env bash

GIT_BIN="$(which git)"

if [[ -z "${GIT_BIN}" ]]; then
    echo "git required but not found in path"
    exit 1
fi
if [[ ! -x "${GIT_BIN}" ]]; then
    echo "git is on path (${GIT_BIN}) but cannot be executed"
    exit 1
fi
