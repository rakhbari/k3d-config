#!/bin/bash

k3d cluster create akc-dev --image rancher/k3s:v1.25.4-k3s1 --agents 3 --k3s-arg "--disable=traefik@server:0"

