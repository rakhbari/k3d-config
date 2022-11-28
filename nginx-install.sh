#!/bin/bash

if ! command -v envsubst &> /dev/null
then
  echo "ERROR: envsubst isn't installed/can't be found. Get it installed on your machine before proceeding. https://www.google.com/search?q=envsubst+command+not+found"
  exit 2
fi

usage() {
  echo ""
  echo "Usage: ${0} <app_name>"
  echo "Example: ${0} nginx-1"
  exit 1
}

export APP_NAME=$1
export NAMESPACE=nginx

if [ -z "${APP_NAME}" ]
then
  echo "ERROR: APP_NAME required."
  usage
fi

echo ""
echo "===> Creating namespace ${NAMESPACE} (if it doesn't exist) ..."
kubectl get ns | grep -q "^${NAMESPACE} " || kubectl create ns ${NAMESPACE}

echo ""
echo "===> Deploying nginx \"${APP_NAME}\" in namespace \"${NAMESPACE}\" ..."
envsubst < k8s/nginx/deployment.yaml | kubectl apply -n ${NAMESPACE} -f -
envsubst < k8s/nginx/service.yaml | kubectl apply -n ${NAMESPACE} -f -
envsubst < k8s/nginx/ingress.yaml | kubectl apply -n ${NAMESPACE} -f -
