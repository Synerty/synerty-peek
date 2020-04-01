#!/usr/bin/env bash

source ./pip_common.sh

reset() {
    SRC_DIR=$1
    shift
    REPOS=$@
    mkdir -p  ${SRC_PATH}
    for repo in ${REPOS}; do
        pushd ${SRC_PATH}/${repo}
        git reset --hard
        git clean -d -f
        popd
    done
}

SRC_PATH=${1:-/tmp}
echo "Cleaning all the repositories at ${SRC_PATH}"
reset ${SRC_PATH} "${PACKAGES[@]}"
reset ${SRC_PATH} "${PLUGINS[@]}"
