#!/bin/bash

# operation: apply/delete
# autocreating a namespace if it doesn't exist

config=$(cat <<EOF
deploys:
- name: kube-state-metrics
  operation: apply
  namespace: kube-system
- name: nfs-driver
  operation: apply
  namespace: kube-system
- name: storage-class
  operation: apply
  namespace: kube-system
- name: atlantis
  operation: apply
  namespace: monitoring
EOF
)

deploy_matrix=$(echo "$config" | yq eval -o=json . | jq -c)
for deploy in $(echo "${deploy_matrix}" | jq -r '.deploys[] | @base64'); do
    _jq() {
        echo ${deploy} | base64 --decode | jq -r ${1}
    }
    DEPLOY_NAME=$(_jq '.name')
    DEPLOY_OPERATION=$(_jq '.operation')
    AUTOCREATE_NAMESPACE=$(_jq '.operation')
    if [ "$DEPLOY_OPERATION" = "apply" ]; then
      echo "Deploying $DEPLOY_NAME"
      kubectl create namespace $AUTOCREATE_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
      kubectl apply -f ./$DEPLOY_NAME/manifests/.
    fi
    if [ "$DEPLOY_OPERATION" = "delete" ]; then
      echo "Deleting $DEPLOY_NAME"
      kubectl delete --ignore-not-found=true -f ./$DEPLOY_NAME/manifests/.
    fi
done
