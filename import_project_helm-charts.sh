#!/bin/bash

cd ./gitlab-projects/helm/helm-charts
git init
git checkout -b main
git remote add origin git@gitlab.tvm2360.ru:helm/helm-charts.git
git add .
git commit -m "Create repository helm/helm-charts"
git push origin main
cd ../../..