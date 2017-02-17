#!/usr/bin/env bash

set -euf -o pipefail

function getS3ImageFileName {
    return "$1.img"
}