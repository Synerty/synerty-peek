#!/usr/bin/env bash

set -o nounset
set -o errexit

# This replaces agent with Whatever
#
# We use "logic", because we just copy LearnPluginDevelopment_AddServer.rst
#   to LearnPluginDevelopment_AddClient.rst and then strip it down.
#

function replace() {
    file="$1"
    to="$2"
    To="$3"
    TO="$4"

    [ -f $file ]

    sed -i "s/server/${to}/g" $file
    sed -i "s/Server/${To}/g" $file
    sed -i "s/SERVER/${TO}/g" $file

}

cp -pr LearnPluginDevelopment_AddClient.rst LearnPluginDevelopment_AddAgent.rst
cp -pr LearnPluginDevelopment_AddClient.rst LearnPluginDevelopment_AddWorker.rst

replace LearnPluginDevelopment_AddClient.rst client Client CLIENT
replace LearnPluginDevelopment_AddAgent.rst agent Agent AGENT
replace LearnPluginDevelopment_AddWorker.rst worker Worker WORKER
