#!/bin/bash
source ./scripts/colors.sh

echo -n "Waiting fot Zookeeper to become ready." 
until kubectl get pods --namespace=kafka 2> /dev/null | grep "zoo" | grep "1/1" | wc -l | xargs | grep -q "5"
do
  printf "."
  sleep 1
done
cecho "OK!" green
