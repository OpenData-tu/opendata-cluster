#!/bin/bash
source ./scripts/colors.sh

function list_topics {
  kubectl exec kafka-client \
    --namespace=kafka -- \
    ./bin/kafka-topics.sh \
    --zookeeper zookeeper.kafka:2181 \
    --list
} 

list_topics
