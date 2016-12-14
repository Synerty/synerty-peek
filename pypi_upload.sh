#!/usr/bin/env bash

set -o nounset
set -o errexit

echo

PACKAGES="synerty-peek
peek_plugin_base
peek_platform
peek_agent
peek_client
peek_client_fe
peek_server
peek_server_fe
peek_worker"

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
