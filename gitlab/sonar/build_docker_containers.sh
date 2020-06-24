#!/usr/bin/env bash

set errexit
set nounset

IMAGE_NAME="peek-linux-sonar"

echo "Building |${IMAGE_NAME}|"

docker build -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME}
docker push nexus.synerty.com:5000/${IMAGE_NAME}

