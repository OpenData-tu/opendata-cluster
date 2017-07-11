#!/bin/bash
source ./scripts/colors.sh
source ./config/kafka_topics

die() { exit 1; }

echo
cecho "Getting Kafak's topics..." yellow

TOPICS=`kubectl exec kafka-client --namespace=kafka -- \
  ./bin/kafka-topics.sh \
  --zookeeper zookeeper.kafka:2181 --list \
  2> /dev/null`

echo 
cecho "Available topics:" blue
cecho $TOPICS blue
echo

function find_topic {
  if echo "$1" | grep -q $2
  then
    cecho "Found: $2" green
  else
    cecho "Error: $2 is not found!" red
    die
  fi
} 

for i in "${kafka_topics[@]}"
do
  find_topic "$TOPICS" $i
done
