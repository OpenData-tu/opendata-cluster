#!/bin/bash
source ./aws_key.sh
source ./env.sh
source ./colors.sh
cat ./.name 

make cluster_init

# Set the context
kubectl config use-context ${CLUSTER_NAME}

# Wait until the cluster is ready
(exec ./wait.sh)

# Remove the old helm and install the new one
make helm_delete
make helm_init
make helm_add_repos

source <(kubectl completion zsh)
source <(helm completion zsh)

# Install Kube Dashboard and Monitoring & Get the Dashboard's password
make install_ui install_monitoring
make get_ui_password

# Install Kafka
sleep 3
helm install --name opendata -f component/kafka/values.yaml incubator/kafka

# Install elasticsearch
kubectl create -f component/elasticsearch/
kubectl annotate service elasticsearch dns.alpha.kubernetes.io/external=es.${DNS_ZONE}

# Scale elasticsearch
kubectl scale rc --replicas=3 es-data

cecho "Done." green 