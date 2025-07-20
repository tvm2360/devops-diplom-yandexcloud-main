#!/bin/bash

cd ./gitlab-projects/kubernetes/ops-k8s-deploy
git init
git checkout -b main
git remote add origin git@gitlab.tvm2360.ru:kubernetes/ops-k8s-deploy.git
git add .
git commit -m "Create repository kubernetes/ops-k8s-deploy"
git push origin main
cd ../../..