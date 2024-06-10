#!/bin/bash

if ! command -v envsubst &> /dev/null
then
  echo "ERROR: envsubst isn't installed/can't be found. Get it installed on your machine before proceeding. https://www.google.com/search?q=envsubst+command+not+found"
  exit 2
fi

usage() {
  echo ""
  echo "Usage: ${0} <app_name> [<host_name>]"
  echo "Example: ${0} nginx-1"
  echo "Note: <host_name> is optional and if not provided will default"
  echo "  to the output of the hostname command."
  exit 1
}

export APP_NAME=$1
export HOST_NAME=$2
export NAMESPACE=nginx

if [ -z "${APP_NAME}" ]
then
  echo "ERROR: APP_NAME required."
  usage
fi

# The given APP_NAME will be used in metadata.name of a few different k8s specs
# Making sure it doesn't contain spaces and/or other illegal characters
APP_NAME=$(echo $APP_NAME | tr " "_"'" - | awk '{print tolower($0)}')

if [ -z "${HOST_NAME}" ]
then
  HOST_NAME=$(hostname | awk '{print tolower($0)}')
  echo "No HOST_NAME provided. Defaulting to: ${HOST_NAME}"
fi

echo "Provided inputs:"
echo "  APP_NAME: ${APP_NAME}"
echo "  HOST_NAME: ${HOST_NAME}"

echo ""
echo "===> Creating namespace ${NAMESPACE} (if it doesn't exist) ..."
kubectl get ns | grep -q "^${NAMESPACE} " || kubectl create ns ${NAMESPACE}

echo ""
echo "===> Deploying nginx app \"${APP_NAME}\" in namespace \"${NAMESPACE}\" ..."
envsubst < k8s/nginx/configmap-app.yaml | kubectl apply -n ${NAMESPACE} -f -
envsubst < k8s/nginx/deployment-app.yaml | kubectl apply -n ${NAMESPACE} -f -
envsubst < k8s/nginx/service-cip.yaml | kubectl apply -n ${NAMESPACE} -f -
envsubst < k8s/nginx/ingress.yaml | kubectl apply -n ${NAMESPACE} -f -
