#!/bin/bash
source ./scripts/colors.sh

function listen_topic {
  kubectl exec -ti kafka-client \
    --namespace=kafka -- \
    ./bin/kafka-console-consumer.sh \
    --bootstrap-server=kafka.kafka:9092 \
    --topic $1 \
    --from-beginning
} 

listen_topic $1
