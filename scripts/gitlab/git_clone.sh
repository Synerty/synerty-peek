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
CI_COMMIT_REF_NAME=${5}
CI_PROJECT_NAMESPACE=${6}

echo "Cloning all the repositories at ${SRC_PATH}"

mkdir -p  ${SRC_PATH} && cd ${SRC_PATH}

# Clone the repos
for repo in ${PACKAGES}; do
    rm -fR ${repo}
    # Shallow? --depth 5
    git clone https://${USER}:${PASSWORD}@gitlab.synerty.com/${CI_PROJECT_NAMESPACE}/${repo}.git &
done

# Wait for background jobs to finish
wait

# Try to switch to a specific branch, otherwise use master
for repo in ${PACKAGES}; do
    pushd ${repo}
    if git fetch origin "${CI_COMMIT_REF_NAME}"; then
        echo "${repo}: Checking out ${CI_COMMIT_REF_NAME}"
        git checkout "${CI_COMMIT_REF_NAME}"
    else
        echo "${repo}: Failed to switch to ${CI_COMMIT_REF_NAME} using master instead"
    fi
    popd
done

