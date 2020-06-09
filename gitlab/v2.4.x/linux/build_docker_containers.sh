#!/usr/bin/env bash

for IMAGE_NAME in peek-linux:v2.4.x peek-linux-build:v2.4.x peek-linux-doc:v2.4.x peek-linux-test:v2.4.x
do
    docker build -t ${IMAGE_NAME} ./${IMAGE_NAME}.Dockerfile
    docker tag ${IMAGE_NAME} nexus.synerty.com:5000/${IMAGE_NAME}
    docker push nexus.synerty.com:5000/${IMAGE_NAME}
done

