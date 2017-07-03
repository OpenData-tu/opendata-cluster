-include .env.mk 
-include .aws_key.mk

# make
.DEFAULT_GOAL := help

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.env.mk: ./config/env.sh ## Load environment variables from env.sh
	@sed 's/"//g ; s/=/:=/' < $< > $@

.aws_key.mk: ./config/aws_key.sh
	@sed 's/"//g ; s/=/:=/' < $< > $@

cluster_init: cluster_create cluster_update ## Initiates the whole cluster.

cluster_update:
	kops update cluster $(CLUSTER_NAME) --yes

cluster_create:
	akops create cluster \
	--zones="us-east-2b" \
	--node-count=$(NODE_COUNT) \
	--node-size=r4.large \
	--node-price=0.015 \
	--master-zones="us-east-2b" \
	--master-size=r4.large \
	--master-price=0.015 \
	--dns-zone=$(DNS_ZONE) \
	--cloud-labels="Owner=Amer,Stack=K8s-opendata" \
	--network-cidr=10.0.0.0/16 \
	--networking weave \
	--topology private \
	--bastion="true" \
	--name $(NAME)

cluster_delete: # Removes all the cluster permanently
	kops delete cluster $(CLUSTER_NAME) --yes

# Monitoring
install_monitoring:
	@kubectl create -f $(MONITORING)

# Dashboard
install_ui: ## Deploys Kube's Dashboard
	@kubectl create -f $(UI)
	@make get_ui_password

get_ui_password: ## Gets the password of the Dashboard
	@kubectl config view --minify | grep -e username -e password -e server

# Explorer
install_explorer: ## Deploys an explorer box.
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
