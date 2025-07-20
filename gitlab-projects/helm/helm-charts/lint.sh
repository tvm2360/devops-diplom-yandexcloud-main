#!/bin/bash

for helm_chart_dir in $(find . -mindepth 2 -maxdepth 2 -type d -not -path '*.git*'); do
  helm lint "$helm_chart_dir" -f "$helm_chart_dir/values.yaml"
done
