#!/bin/bash

echo ""
echo "===> Installing MetalLB specs ..."
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
