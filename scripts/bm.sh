#!/bin/bash

curl -s http://a084e61c167b811e786bd06eea5b0669-421521297.us-east-2.elb.amazonaws.com:9200/wdi-2017.07.13/_count | jq -r '.count'

