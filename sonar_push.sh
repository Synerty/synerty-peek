#!/usr/bin/env bash

source ./pip_common.sh

sonar() {
    SRC_DIR=$1
    shift
    REPOS=$@
    for REPO in ${REPOS[*]}
    do
        pushd ${SRC_DIR}/${REPO}
        if [[ -f "sonar-project.properties" ]]; then
            echo "Pushing ${REPO} to SonarQube"
            sonar-scanner
        fi
        popd
    done
}

SRC_PATH=${1:-/tmp}
echo "Scanning source code : ${SRC_PATH}"
sonar ${SRC_PATH} "${PACKAGES[@]}"
sonar ${SRC_PATH} "${PLUGINS[@]}"
