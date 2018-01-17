#!/bin/bash

set -euf -o pipefail

pw=""

if [[ -z "${pw}" ]]; then
    gpg2_bin=$(which gpg2)
    if [[ -n "${gpg2_bin}" ]]; then
	pw="$(${gpg2_bin} --armor --gen-random 1 15)"
    fi
fi

if [[ -z "${pw}" ]]; then
    openssl_bin=$(which openssl)
    if [[ -n "${openssl_bin}" ]]; then
	pw="$(${openssl_bin} rand -base64 15)"
    fi
fi

if [[ -z "${pw}" ]]; then
    head_bin=$(which head)
    if [[ -n "${head_bin}" ]]; then
	strings_bin=$(which strings)
	if [[ -n "${strings_bin}" ]]; then
	    tr_bin=$(which tr)
	    if [[ -n "${tr_bin}" ]]; then
		if [[ -r "/dev/urandom" ]]; then
		    pw="$(${head_bin} -c100 /dev/urandom | ${strings_bin} -n1 | ${tr_bin} -d '[:space:]' | ${head_bin} -c15)"
		fi
	    fi
	fi
    fi
fi

pw_bin=$(which pw)
if [[ -z "${pw_bin}" ]]; then
    >&2 echo "pw binary not in path, cannot set password"
fi

if [[ ! -x "${pw_bin}" ]]; then
    >&2 echo "pw binary ${pw_bin} not executable, cannot set password"
fi

if [[ -z "${pw}" ]]; then
    >&2 echo "Could not find any method to generate random password (tried gpg2, openssl, head/strings/tr/urandom)"
    echo -n "Disabling root password... "
    ${pw_bin} usermod root -h -
    echo "done!"
fi

echo -n "Setting root password to '${pw}'... "
echo "${pw}" | ${pw_bin} usermod root -h 0
echo "done!"
