#!/bin/bash

# https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files

BASE_IMAGE=docker.io/library/debian:bullseye
IMAGE_NAME=openwrt-builder


if which podman; then
  DOCKER_CMD='podman'
  DOCKER_ARG='--userns=keep-id'
else
  DOCKER_CMD='docker'
fi

# check for selinux
which getenforce && SELINUX=':z'

# pull image
${DOCKER_CMD} pull ${BASE_IMAGE}

# builder container 
${DOCKER_CMD} build -t ${IMAGE_NAME} .

# run shell in container
echo "RUN:
${DOCKER_CMD} run ${DOCKER_ARG} -u $(id -u) --rm -v $(pwd):/home/builder/build${SELINUX} -it ${IMAGE_NAME} /bin/bash
"

${DOCKER_CMD} run ${DOCKER_ARG} -u "$(id -u)" --rm -v "$(pwd):/home/builder/build${SELINUX}" -it ${IMAGE_NAME} /bin/bash
