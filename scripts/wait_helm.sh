#!/bin/bash
source  ./scripts/colors.sh

cecho "Waiting fot Helm tiller" blue
until kubectl get services --namespace=kube-system 2> /dev/null | grep -q "tiller"
do
  printf "."
  sleep 1
done
cecho "OK!" green

