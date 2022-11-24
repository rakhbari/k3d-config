#!/bin/bash

export ingress_range=$(./cidr-range.sh)

echo "MetalLB ingress_range: ${ingress_range}"

echo ""
echo "===> Applying MetalLB config specs ..."
envsubst < metallb-config.yaml | kubectl apply -f -
