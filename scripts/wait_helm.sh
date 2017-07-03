#!/bin/bash
source  ./scripts/colors.sh

echo -n "Waiting fot Helm tiller to become ready" 
until kubectl get pods --namespace=kube-system 2> /dev/null | grep "tiller" | grep -q "1/1"
do
  printf "."
  sleep 1
done
cecho "OK!" green

