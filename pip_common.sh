#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

export PACKAGES="
peek-plugin-base
peek-platform
peek-agent
peek-worker
peek-client-fe
peek-client
peek-server-fe
peek-server
synerty-peek"

export bold=$(tput bold)
export normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "$0 must be run in the directory where setup.py is" >&2
    exit 1
fi
