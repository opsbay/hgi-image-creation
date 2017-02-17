#!/usr/bin/env bash

set -euf -o pipefail

function getS3ImageFileName {
    echo "$1.img"
}