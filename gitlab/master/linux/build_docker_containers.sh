#!/usr/bin/env bash

set errexit
set nounset

BRANCH=master

for IMAGE_NAME in peek-linux peek-linux-build peek-linux-doc peek-linux-test
do
    IMAGE_NAME="${IMAGE_NAME}:${BRANCH}"
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME}
    docker push nexus.synerty.com:5000/${IMAGE_NAME}

done
