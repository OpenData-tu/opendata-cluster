#!/bin/bash
source ./scripts/colors.sh
source ./config/kafka_topics

function create_topic {
  kubectl exec kafka-client \
    --namespace=kafka -- \
    ./bin/kafka-topics.sh \
    --zookeeper zookeeper.kafka:2181 \
    --topic $1 --create \
    --partitions $2 \
    --replication-factor $3
} 

for i in "${kafka_topics[@]}"
do
  create_topic $i 3 3
done
