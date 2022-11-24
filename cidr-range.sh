#!/bin/bash

CLUSTER_NAME="k3d-akc"

# determine loadbalancer ingress range
cidr_block=$(docker network inspect ${CLUSTER_NAME} | jq '.[0].IPAM.Config[0].Subnet' | tr -d '"')
cidr_base_addr=${cidr_block%???}
ingress_first_addr=$(echo $cidr_base_addr | awk -F'.' '{print $1,$2,200,2}' OFS='.')
ingress_last_addr=$(echo $cidr_base_addr | awk -F'.' '{print $1,$2,200,254}' OFS='.')
ingress_range=$ingress_first_addr-$ingress_last_addr

echo -n "${ingress_range}"
