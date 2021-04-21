#!/usr/bin/env bash

set errexit
set nounset

IMAGE_NAMES=""
IMAGE_NAMES="${IMAGE_NAMES} peek-centos:master "
#IMAGE_NAMES="${IMAGE_NAMES} peek-centos-test:master "
#IMAGE_NAMES="${IMAGE_NAMES} peek-centos-sonar:master "
IMAGE_NAMES="${IMAGE_NAMES} peek-centos-build:master "
#IMAGE_NAMES="${IMAGE_NAMES} peek-centos-doc:master "

for IMAGE_NAME in ${IMAGE_NAMES}; do
    echo "Building |${IMAGE_NAME}|"

    docker build -t ${IMAGE_NAME} -f ${IMAGE_NAME}.Dockerfile .
    docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME}
    docker push nexus.synerty.com:5000/${IMAGE_NAME}

    if [[ ${IMAGE_NAME} == *aster ]]; then
        docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME/master/latest}
        docker push nexus.synerty.com:5000/${IMAGE_NAME/master/latest}
    fi

done
