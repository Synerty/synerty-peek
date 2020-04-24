#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

# Also update setup.py
export PLATFORM_PKGS="
peek-plugin-base
peek-platform
peek-agent
peek-desktop
peek-worker
peek-mobile
peek-client
peek-doc-user
peek-admin
peek-doc-admin
peek-doc-dev
peek-server
peek-storage
synerty-peek
peek-core-email
peek-core-device
peek-core-user
peek-core-search
peek-abstract-chunked-index"


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
peek-plugin-docdb
peek-plugin-docdb-generic-menu
peek-plugin-diagram
peek-plugin-pof-sql
peek-plugin-pof-soap
peek-plugin-pof-chat
peek-plugin-pof-switching
peek-plugin-pof-field-switching
peek-plugin-pof-field-incidents
peek-plugin-pof-field-assessments
peek-plugin-pof-field-online
peek-plugin-pof-event
peek-plugin-gis-diagram
peek-plugin-pof-diagram
peek-plugin-pof-diagram-loader
peek-plugin-pof-equipment-loader
peek-plugin-pof-switching-loader
peek-plugin-pof-livedb-loader
peek-plugin-pof-graphdb-loader
peek-plugin-gis-diagram-loader
peek-plugin-pof-gis-location-loader
peek-plugin-pof-user-loader
peek-plugin-pof-email-nar
peek-plugin-pof-email-incidents
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
