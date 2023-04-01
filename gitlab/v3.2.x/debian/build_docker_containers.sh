#!/usr/bin/env bash

set -o errexit
set -o nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-debian:v3.2.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-test:v3.2.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-sonar:v3.2.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-build:v3.2.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-doc:v3.2.x "

for IMAGE_NAME in ${IMAGE_NAMES}
do
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]
    then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME/v3.2.x/latest}
        docker push nexus.synerty.com:5001/${IMAGE_NAME/v3.2.x/latest}
    fi

done
