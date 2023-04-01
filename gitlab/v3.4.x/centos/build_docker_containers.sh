#!/usr/bin/env bash

set -o errexit
set -o nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-centos:v3.4.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-test:v3.4.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-sonar:v3.4.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-build:v3.4.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-doc:v3.4.x "

for IMAGE_NAME in ${IMAGE_NAMES}
do
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]
    then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME/v3.4.x/latest}
        docker push nexus.synerty.com:5001/${IMAGE_NAME/v3.4.x/latest}
    fi

done
