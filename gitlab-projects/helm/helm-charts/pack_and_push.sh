#!/bin/bash

for helm_chart in $(find . -mindepth 2 -maxdepth 2 -type d -not -path '*.git*'); do
  echo "Pack chart: $helm_chart"
  helm package "$helm_chart"
done

for helm_chart in $(find . -mindepth 1 -maxdepth 1 -type f -name "*.tgz"); do
  echo "Push chart: $helm_chart"
   helm push "$helm_chart" oci://$CI_REGISTRY/$CI_REPOSITORY
done
