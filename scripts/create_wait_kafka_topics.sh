#!/bin/bash
source ./scripts/colors.sh

# Checking topics
until ./scripts/check_kafka_topics.sh 
do
  (exec ./scripts/create_kafka_topics.sh)  
  printf "."
  sleep 1
done
cecho "OK!" green
