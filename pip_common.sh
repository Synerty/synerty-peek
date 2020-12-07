#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

# Also update setup.py
export COMMUNITY_PLUGINS="
peek-plugin-branch
peek-plugin-chat
peek-plugin-data-dms
peek-plugin-diagram
peek-plugin-diagram-trace
peek-plugin-diagram-positioner
peek-plugin-docdb-generic-menu
peek-plugin-eventdb
peek-plugin-gis-diagram
peek-plugin-gis-diagram-loader
peek-plugin-graphdb
peek-plugin-inbox
peek-plugin-index-blueprint
peek-plugin-livedb
peek-plugin-noop
peek-plugin-tutorial
"

export COMMUNITY_PKGS="
peek-abstract-chunked-data-loader
peek-abstract-chunked-index
peek-admin-app
peek-agent-service
peek-core-device
peek-core-docdb
peek-core-email
peek-core-search
peek-core-user
peek-core-screen
peek-doc-admin
peek-doc-dev
peek-doc-user
peek-field-app
peek-field-service
peek-logic-service
peek-office-app
peek-office-service
peek-plugin-base
peek-platform
peek-storage-service
peek-worker-service
synerty-peek
${COMMUNITY_PLUGINS}
"

# Dynamicall list plugins

# Get the location of this script
#here=$(dirname `readlink -f $(dirname $0)`)
#echo $here

## Plugins are siblings to this project
#if ls -d $here/peek-plugin-* 2> /dev/null 2>&1; then
#    export ENTERPRISE_PKGS=`ls -d $here/peek-plugin-* | grep -v peek-plugin-base`
#else
#    echo "There are no plugins at $here"
#    export ENTERPRISE_PKGS=""
#fi

# Ignore all that, define the ones JJC wants for Orion

export ENTERPRISE_PKGS="
peek-plugin-diagram-zepben-menu
peek-plugin-enmac-chat
peek-plugin-enmac-diagram
peek-plugin-enmac-diagram-loader
peek-plugin-enmac-email-incidents
peek-plugin-enmac-email-nar
peek-plugin-enmac-equipment-loader
peek-plugin-enmac-event
peek-plugin-enmac-event-loader
peek-plugin-enmac-field-assessments
peek-plugin-enmac-field-incidents
peek-plugin-enmac-field-online
peek-plugin-enmac-field-switching
peek-plugin-enmac-gis-location-loader
peek-plugin-enmac-graphdb-loader
peek-plugin-enmac-livedb-loader
peek-plugin-enmac-soap
peek-plugin-enmac-sql
peek-plugin-enmac-switching
peek-plugin-enmac-switching-loader
peek-plugin-enmac-user-loader
"
## DEPREICATED ENTERPRISE_PKGS
# peek-plugin-gis-dms-positioner

export bold=$(tput bold)
export normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "$0 must be run in the directory where setup.py is" >&2
    exit 1
fi
