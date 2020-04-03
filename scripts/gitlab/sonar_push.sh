#!/usr/bin/env bash

source ./pip_common.sh

if [ "${1}" = 'platform' ]; then
    PACKAGES=${PLATFORM_PKGS}
elif [ "${1}" = 'plugins' ]; then
    PACKAGES=${PLUGIN_PKGS}
else
    echo "Arg1 is not 'plugins' or 'platform' " >&2
    exit 1
fi

SRC_PATH=${2:-/tmp}

echo "Scanning source code : ${SRC_PATH}"

for REPO in ${PACKAGES}
do
    pushd ${SRC_PATH}/${REPO}
    if [[ -f "sonar-project.properties" ]]; then
        echo "Pushing ${REPO} to SonarQube"
        sonar-scanner &
    fi
    popd
done

# Wait for background jobs to finish
wait

