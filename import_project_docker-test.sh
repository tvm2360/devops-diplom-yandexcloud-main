#!/bin/bash

cd ./gitlab-projects/docker/test
git init
git checkout -b main
git remote add origin git@gitlab.tvm2360.ru:docker/test.git
git add .
git commit -m "Create repository docker/test"
git push origin main
cd ../../..
