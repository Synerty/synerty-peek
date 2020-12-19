#!/usr/bin/env bash

set errexit
set nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-linux:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-test:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-build:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-linux-doc:master "

for IMAGE_NAME in ${IMAGE_NAMES}; do
    echo "Building |${IMAGE_NAME}|"

    docker build --no-cache -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME}
    docker push nexus.synerty.com:5000/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]
    then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME/master/latest}
        docker push nexus.synerty.com:5000/${IMAGE_NAME/master/latest}
    fi

done
