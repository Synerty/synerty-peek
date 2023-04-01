#!/usr/bin/env bash

set -o errexit
set -o nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-linux:v3.0.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-test:v3.0.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-sonar:v3.0.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-build:v3.0.x "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-doc:v3.0.x "

for IMAGE_NAME in ${IMAGE_NAMES}
do
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

done
