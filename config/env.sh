export NAME=o.thinkdeep.io
export CLUSTER_NAME=${NAME}
export USER_NAME=kops
export DNS_ZONE=o.thinkdeep.io
export KOPS_STATE_STORE=s3://o-thinkdeep-io-state-store

export NODE_COUNT=3 
export ZONES=us-east-2b
export MASTER_ZONES=us-east-2b
export CLOUD_LABELS="Owner=Amer,Stack=K8s-opendata"
export NETWORK_CIDR=10.0.0.0/16

export UI=https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.6.0.yaml
export MONITORING=https://raw.githubusercontent.com/kubernetes/kops/master/addons/monitoring-standalone/v1.6.0.yaml 

export EXPLORER=https://raw.githubusercontent.com/kubernetes/kubernetes/master/examples/explorer/pod.yaml
export EXPLORER_URL=http://localhost:8001/api/v1/proxy/namespaces/default/pods/explorer:8080/
