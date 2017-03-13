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

export PLUGINS="
peek-plugin-active-task
peek-plugin-data-dms
peek-plugin-pof-soap
peek-plugin-user
peek-plugin-pof-field-switching
peek-plugin-pof-sql"


export bold=$(tput bold)
export normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "$0 must be run in the directory where setup.py is" >&2
    exit 1
fi
