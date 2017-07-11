#!/bin/bash
source ./scripts/colors.sh

echo -n "Waiting fot Elasticsearch master to become ready." 
until kubectl get pods 2> /dev/null | grep "es-master" | grep "1/1" | wc -l | xargs | grep -q "3"
do
  printf "."
  sleep 1
done
cecho "OK!" green
