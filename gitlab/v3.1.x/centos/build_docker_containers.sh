#!/usr/bin/env bash

set -o errexit
set -o nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-centos:v3.1.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-test:v3.1.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-sonar:v3.1.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-build:v3.1.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-doc:v3.1.x "

for IMAGE_NAME in ${IMAGE_NAMES}
do
    echo "Building |${IMAGE_NAME}|"

    docker build -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]
    then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME/v3.1.x/latest}
        docker push nexus.synerty.com:5001/${IMAGE_NAME/v3.1.x/latest}
    fi

done
