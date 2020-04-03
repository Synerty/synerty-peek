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
USER=${3}
PASSWORD=${4}

echo "Cloning all the repositories at ${SRC_PATH}"

mkdir -p  ${SRC_PATH} && cd ${SRC_PATH}

for repo in ${PACKAGES}; do
    rm -fR ${repo}
    echo ${repo}
    git clone https://${USER}:${PASSWORD}@gitlab.synerty.com/peek/${repo}.git &
done

# Wait for background jobs to finish
wait

