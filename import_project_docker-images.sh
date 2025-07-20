#!/bin/bash

cd ./gitlab-projects/docker/docker-images
git init
git checkout -b main
git remote add origin git@gitlab.tvm2360.ru:docker/docker-images.git
git add .
git commit -m "Create repository docker/dockerimage"
git push origin main
cd ../../..
