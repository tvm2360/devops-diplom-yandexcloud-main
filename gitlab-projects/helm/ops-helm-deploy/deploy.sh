#!/bin/bash

config=$(cat <<EOF
charts:
- chart_name: proxy
  release_name: proxy
  namespace: tvm2360
  versions: 2.4.41
- chart_name: node-exporter
  release_name: node-exporter
  namespace: monitoring
  versions: 1.6.0
- chart_name: prometheus
  release_name: prometheus
  namespace: monitoring
  versions: 1.6.0
- chart_name: grafana
  release_name: grafana
  namespace: monitoring
  versions: 1.5.1
EOF
)
chart_matrix=$(echo "$config" | yq eval -o=json . | jq -c)
for chart in $(echo "${chart_matrix}" | jq -r '.charts[] | @base64'); do
    _jq() {
        echo ${chart} | base64 --decode | jq -r ${1}
    }
    CHART_NAME=$(_jq '.chart_name')
    RELEASE_NAME=$(_jq '.release_name')
    RELEASE_NAMESPACE=$(_jq '.namespace')
    CHART_VER=$(_jq '.versions')
    if [ -f "./values/$CHART_NAME/values.yaml" ]; then
      echo "Deploying $CHART_NAME version $CHART_VER within namespace $RELEASE_NAMESPACE"
      helm upgrade --install $RELEASE_NAME -f ./values/$CHART_NAME/values.yaml oci://$CI_REGISTRY/$CI_REPOSITORY/$CHART_NAME --version $CHART_VER --namespace $RELEASE_NAMESPACE --create-namespace --wait
    else
      echo "values.yaml not found for $CHART_NAME, skipping deployment"
    fi
done
