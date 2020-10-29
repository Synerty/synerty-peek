#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

# Also update setup.py
export PLATFORM_PKGS="
peek-plugin-base
peek-platform
peek-agent-service
peek-office-app
peek-worker-service
peek-field-app
peek-office-service
peek-doc-user
peek-admin-app
peek-doc-admin
peek-doc-dev
peek-logic-service
peek-storage-service
synerty-peek
peek-core-email
peek-core-device
peek-core-user
peek-core-search
peek-abstract-chunked-index
peek-abstract-chunked-data-loader"


# Dynamicall list plugins

# Get the location of this script
#here=$(dirname `readlink -f $(dirname $0)`)
#echo $here

## Plugins are siblings to this project
#if ls -d $here/peek-plugin-* 2> /dev/null 2>&1; then
#    export PLUGIN_PKGS=`ls -d $here/peek-plugin-* | grep -v peek-plugin-base`
#else
#    echo "There are no plugins at $here"
#    export PLUGIN_PKGS=""
#fi

# Ignore all that, define the ones JJC wants for Orion

export PLUGIN_PKGS="
peek-plugin-noop
peek-plugin-tutorial
peek-plugin-index-blueprint
peek-plugin-data-dms
peek-plugin-branch
peek-plugin-inbox
peek-plugin-chat
peek-plugin-livedb
peek-plugin-graphdb
peek-plugin-eventdb
peek-core-docdb
peek-plugin-docdb-generic-menu
peek-plugin-diagram
peek-plugin-enmac-sql
peek-plugin-enmac-soap
peek-plugin-enmac-chat
peek-plugin-enmac-switching
peek-plugin-enmac-field-switching
peek-plugin-enmac-field-incidents
peek-plugin-enmac-field-assessments
peek-plugin-enmac-field-online
peek-plugin-enmac-event
peek-plugin-gis-diagram
peek-plugin-enmac-diagram
peek-plugin-enmac-diagram-loader
peek-plugin-enmac-equipment-loader
peek-plugin-enmac-switching-loader
peek-plugin-enmac-livedb-loader
peek-plugin-enmac-graphdb-loader
peek-plugin-gis-diagram-loader
peek-plugin-enmac-gis-location-loader
peek-plugin-enmac-user-loader
peek-plugin-enmac-email-nar
peek-plugin-enmac-email-incidents
peek-plugin-enmac-event-loader
peek-plugin-diagram-zepben-menu
peek-plugin-diagram-trace
peek-plugin-diagram-positioner"

## DEPREICATED PLUGIN_PKGS
# peek-plugin-gis-dms-positioner

export bold=$(tput bold)
export normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "$0 must be run in the directory where setup.py is" >&2
    exit 1
fi
