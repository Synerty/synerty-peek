#!/usr/bin/env bash

source ./pip_common.sh

clone() {
    SRC_DIR=$1
    USER=$2
    PASSWORD=$3
    shift
    shift
    shift
    REPOS=$@
    mkdir -p  ${SRC_PATH}
    pushd ${SRC_PATH}
    for repo in ${REPOS}; do
        rm -fR ${repo}
        git clone https://${USER}:${PASSWORD}@gitlab.synerty.com/peek/${repo}.git
        echo ${repo}
    done
    popd
}

SRC_PATH=${1:-/tmp}
USER=${2}
PASSWORD=${3}
echo "Cloning all the repositories at ${SRC_PATH}"
clone ${SRC_PATH} ${USER} ${PASSWORD} "${PACKAGES[@]}"
clone ${SRC_PATH} ${USER} ${PASSWORD} "${PLUGINS[@]}"


