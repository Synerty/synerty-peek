#!/usr/bin/env bash

set -o errexit
set -o nounset

for IMAGE_NAME in peek-linux:v2.4.x peek-linux-build:v2.4.x peek-linux-doc:v2.4.x peek-linux-test:v2.4.x
do
    echo "Building |${IMAGE_NAME}|"

    docker build -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5001/${IMAGE_NAME}
    docker push nexus.synerty.com:5001/${IMAGE_NAME}

done
