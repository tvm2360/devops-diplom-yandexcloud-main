#!/bin/bash

cd ./gitlab-projects/helm/ops-helm-deploy
git init
git checkout -b main
git remote add origin git@gitlab.tvm2360.ru:helm/ops-helm-deploy.git
git add .
git commit -m "Create repository helm/ops-helm-deploy"
git push origin main
cd ../../..