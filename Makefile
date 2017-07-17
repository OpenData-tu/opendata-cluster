-include .env.mk 
-include .aws_key.mk

ifeq (listen,$(firstword $(MAKECMDGOALS)))
  LISTEN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(LISTEN_ARGS):;@:)
endif


.PHONY: listen
listen: ## Listen to a kafka topic. E.g.: make listen ${TOPIC_NAME}
	@./scripts/listen_kafka_topic.sh $(LISTEN_ARGS)

# make
.DEFAULT_GOAL := help

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

# Load environment variables from env.sh
.env.mk: ./config/env.sh
	@sed 's/"//g ; s/=/:=/' < $< > $@

.aws_key.mk: ./config/aws_key.sh
	@sed 's/"//g ; s/=/:=/' < $< > $@

init: ## Create the cluster and install everything
	@bash ./scripts/init

down: cluster_delete

# Initiates the whole cluster.
cluster_init: cluster_create cluster_config cluster_update

# To enable cronjob APIs it will add:
#  kubeAPIServer:
#    cloudProvider: aws
#    runtimeConfig:
#      batch/v2alpha1: "true"
cluster_config:
	kops replace -f ./config/kops.cluster.yaml

cluster_update:
	@kops update cluster $(NAME) --yes

cluster_create:
	akops create cluster \
	--ssh-public-key=~/.ssh/id_opendata_rsa.pub \
	--cloud=aws \
	--zones=$(ZONES) \
	--node-count=$(NODE_COUNT) \
	--node-size=r4.large \
	--node-price=0.015 \
	--master-zones=$(MASTER_ZONES) \
	--master-size=r4.large \
	--master-price=0.015 \
	--dns-zone=$(DNS_ZONE) \
	--cloud-labels=$(CLOUD_LABELS) \
	--network-cidr=$(NETWORK_CIDR) \
	--networking weave \
	--topology private \
	--bastion \
	--kubernetes-version=1.7.0 \
	--name $(NAME)

cluster_delete: ## Removes all the cluster permanently
	kops delete cluster $(NAME) --yes

# Monitoring
install_monitoring:
	@kubectl create -f $(MONITORING)

# Dashboard
# Deploys Kube's Dashboard
install_ui:
	@kubectl create -f $(UI)

get_ui_password: ## Gets the password of the Dashboard
	@kubectl config view --minify | grep -e username -e password -e server

# Explorer
# Deploys an explorer box.
install_explorer:
	@kubectl create -f $(EXPLORER)

delete_explorer:
	@kubectl delete -f $(EXPLORER)

open_explorer:
	@echo "Make sure to run the proxy first!!!"
	@echo "kubectl proxy"
	open $(EXPLORER_URL) 

# Helm
helm_add_repos:
	@helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
	@helm repo add cnct http://atlas.cnct.io	

helm_delete:
	-@rm -rf `helm home`

helm_init:
	@helm init

topics: ## List Kafka topics
	@./scripts/list_kafka_topics.sh

deploy_consumers:
	kubectl create -f component/docker-logstash-kafka-es/logstash-kafka-es-rc.yaml
#	kubectl create -f component/consumers/

delete_consumers:
	kubectl delete -f component/docker-logstash-kafka-es/logstash-kafka-es-rc.yaml
#	kubectl delete -f component/consumers/

deploy_jobs:
	kubectl create -f jobs

deljobs: ## Delete all job in the default namespace
	@bash ./scripts/deljobs.sh

rec: delete_consumers deploy_consumers ## Redeploy consumers

