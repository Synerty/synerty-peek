#!/usr/bin/env bash

source ./pip_common.sh

if [ "${1}" = 'community' ]
then
    PACKAGE_GRP="community"
    PACKAGES=${COMMUNITY_PKGS}
elif [ "${1}" = 'enterprise' ]
then
    PACKAGE_GRP="enterprise"
    PACKAGES=${ENTERPRISE_PKGS}
else
    echo "Arg1 is not 'community' or 'enterprise' " >&2
    exit 1
fi

SRC_PATH=${2:-/tmp}
USER=${3}
PASSWORD=${4}
CI_COMMIT_REF_NAME=${5}
CI_PROJECT_NAMESPACE=${6}
RELEASE_BRANCH=${7}

# we're on gitlab 12.9 there's no $CI_PROJECT_ROOT_NAMESPACE as in 13.3 or later
CI_PROJECT_ROOT_NAMESPACE=${CI_PROJECT_NAMESPACE%/*}

echo "Cloning all the repositories at ${SRC_PATH}"

mkdir -p ${SRC_PATH} && cd ${SRC_PATH}

# Clone the repos
repoUrls=""
for repo in ${PACKAGES}
do
    rm -fR ${repo}

    if [ "${CI_PROJECT_ROOT_NAMESPACE}" = 'peek' ]
    then
        pathTo=peek/${PACKAGE_GRP}
    else
        pathTo=${CI_PROJECT_ROOT_NAMESPACE}/${PACKAGE_GRP}
    fi
    repoUrls="${repoUrls} https://${USER}:${PASSWORD}@gitlab.synerty.com/${pathTo}/${repo}.git"
done

echo ${repoUrls} | xargs -n1 -P4 git clone


# Try to switch to a specific branch, otherwise use master
for repo in ${PACKAGES}
do
    pushd ${repo}
    if git fetch origin "${CI_COMMIT_REF_NAME}"
    then
        echo "${repo}: Checking out ${CI_COMMIT_REF_NAME}"
        git checkout "${CI_COMMIT_REF_NAME}"

    elif git fetch origin "${RELEASE_BRANCH}"
    then
        echo "${repo}: Checking out ${RELEASE_BRANCH}"
        git checkout "${RELEASE_BRANCH}"
    else
        echo "${repo}: Failed to switch to ${CI_COMMIT_REF_NAME}" >&2
        echo "${repo}: Failed to switch to ${RELEASE_BRANCH}" >&2
        echo "${repo}: Using master instead" >&2
    fi
    popd
done
