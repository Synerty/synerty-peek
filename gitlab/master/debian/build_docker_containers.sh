#!/usr/bin/env bash

set -o errexit
set -o nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-debian:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-test:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-sonar:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-build:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-debian-doc:master "

for IMAGE_NAME in ${IMAGE_NAMES}; do
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]; then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME/master/latest}
        docker push nexus.synerty.com:5001/${IMAGE_NAME/master/latest}
    fi

done
