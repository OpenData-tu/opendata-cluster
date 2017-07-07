#!/bin/bash
source  ./scripts/colors.sh

echo -n "Waiting fot Kafka to become ready." 
until kubectl get pods --namespace=kafka 2> /dev/null | grep "kafka" | grep -q "1/1"
do
  printf "."
  sleep 1
done
cecho "OK!" green
