#!/bin/bash
source ./scripts/colors.sh

# Checking topics
until ./scripts/check_kafka_topics.sh 
do
  printf "."
  sleep 1
done
cecho "OK!" green
