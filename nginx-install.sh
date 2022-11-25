#!/bin/bash

kubectl create namespace nginx
kubectl create deployment nginx -n nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer -n nginx
