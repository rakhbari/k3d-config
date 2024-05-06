#!/bin/bash

export CLUSTER_NAME=$1

if [ -z "${CLUSTER_NAME}" ]
then
  echo "ERROR: CLUSTER_NAME is required."
  exit 1
fi

export ingress_range=$(./cidr-range.sh "${CLUSTER_NAME}")

echo "MetalLB ingress_range: ${ingress_range}"

echo ""
echo "===> Applying MetalLB config specs ..."
envsubst < metallb-config.yaml | kubectl apply -f -
