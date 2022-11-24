#!/bin/bash

echo ""
echo "===> Installing MetalLB specs ..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
