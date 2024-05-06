#!/bin/bash

export NAMESPACE=${1}
export SERVICE_ACCT=${2}

usage() {
  echo ""
  echo "Usage: ${0} <namespace> <service_acct>"
  exit 1
}

if [ -z "${NAMESPACE}" ] || [ -z "${SERVICE_ACCT}" ]
then
  echo "ERROR: NAMESPACE and SERVICE_ACCT are required."
  usage
fi

echo ""
TOKEN="$(kubectl get secret ${SERVICE_ACCT}-token -n ${NAMESPACE} -o=jsonpath='{.data.token}' | base64 --decode)"
printf "===> TOKEN for SA ${NAMESPACE}:${SERVICE_ACCT}:\n${TOKEN}\n"
echo ""
