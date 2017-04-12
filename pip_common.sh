#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

export PACKAGES="
peek-plugin-base
peek-platform
peek-agent
peek-worker
peek-mobile
peek-client
peek-admin
peek-server
synerty-peek"

export PLUGINS="
peek-plugin-active-task
peek-plugin-user
peek-plugin-chat
peek-plugin-data-dms
peek-plugin-pof-field-switching
peek-plugin-pof-sql
peek-plugin-pof-soap
peek-plugin-pof-chat"


export bold=$(tput bold)
export normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "$0 must be run in the directory where setup.py is" >&2
    exit 1
fi
