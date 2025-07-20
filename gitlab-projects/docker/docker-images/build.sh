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
      if [ -f ./$docker_image_dir/Dockerfile ]; then
         cd ./$docker_image_dir
         docker build -t $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION_TAG .
         docker build -t $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .
         cd ..
      fi
    else
      if [ -f ./$docker_image_dir/Dockerfile ]; then
         cd ./$docker_image_dir
         DOCKER_IMAGE_VERSION_TAG=""
         docker build -t $CI_REGISTRY/$CI_REPOSITORY/$DOCKER_IMAGE_PREFIX$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .
         cd ..
      fi
    fi
  done