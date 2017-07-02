#!/bin/bash
source ./colors.sh
echo -n "Waiting for cluster components to become ready."
until [ $(kubectl get cs 2> /dev/null| grep -e Healthy | wc -l | xargs) -ge 4 ]
do
  echo -n "."
  sleep 1
done
cecho "Ok!" green

echo -n "Waiting for minimum nodes to become ready."
min_nodes=$(kops get ig nodes --name ${CLUSTER_NAME} | grep nodes | awk '{print $4}')
until [ "$(kubectl get nodes 2> /dev/null| grep -v master | grep -e Ready | wc -l | xargs)" == "$NODE_COUNT" ]
do
  echo -n "."
  sleep 1
done
cecho "Ok!" green
