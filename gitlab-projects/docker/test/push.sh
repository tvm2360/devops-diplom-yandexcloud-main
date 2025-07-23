#!/bin/sh

if [ -f ./$docker_image_dir/.docker_image_prefix ]; then
  DOCKER_IMAGE_PREFIX="$(tr -d '\n' < ./$docker_image_dir/.docker_image_prefix)-"
else
  DOCKER_IMAGE_PREFIX=""
fi

for docker_image_dir in $(ls -d -- */ | sed 's/.$//')
  do
    DOCKER_IMAGE_NAME=$docker_image_dir
    if [ -f ./$docker_image_dir/.version ]; then
      DOCKER_IMAGE_VERSION_TAG=$(tr -d '\n' < ./$docker_image_dir/.version)
      docker push $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_TAG
      docker push $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG
    else
      DOCKER_IMAGE_VERSION_TAG=""
      docker push $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG
    fi
  done