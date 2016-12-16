#!/usr/bin/env bash

set -o nounset
set -o errexit

echo

PACKAGES="
peek-plugin-base
peek-platform
peek-agent
peek-worker
peek-client
peek-client-fe
peek-server
peek-server-fe
synerty-peek"

bold=$(tput bold)
normal=$(tput sgr0)


# -------------------------------------
echo "Uploading to PYPI"
EXIT=""
for pkg in $PACKAGES; do
    if ! (cd ../$pkg && python setup.py sdist upload -r pypi); then
        echo "${bold}${pkg}${normal} : Failed to build and upload to pypi" >&2
        exit 1
    fi
done
