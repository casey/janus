MINIKUBE_ARGS="--vm-driver virtualbox --memory 2048"
KUBERNETES_VERSION="v1.10.6"
KUBELESS_VERSION="v1.0.0-alpha.7"

# Prepare the development environment based on minikube
clst-prepare:
    #!/usr/bin/env bash
    set -xe
    export KUBERNETES_VERSION="{{KUBERNETES_VERSION}}"
    export KUBELESS_VERSION="{{KUBELESS_VERSION}}"
    export MINIKUBE_ARGS="--kubernetes-version={{KUBERNETES_VERSION}} {{MINIKUBE_ARGS}}"

    minikube start ${MINIKUBE_ARGS}
    minikube addons enable ingress
    kubectl create ns kubeless
    kubectl create -f https://github.com/kubeless/kubeless/releases/download/${KUBELESS_VERSION}/kubeless-${KUBELESS_VERSION}.yaml
    kubectl create -f https://github.com/kubeless/kubeless/releases/download/${KUBELESS_VERSION}/kafka-zookeeper-${KUBELESS_VERSION}.yaml

# A wrapper for starting minikube
clst-start:
    #!/usr/bin/env bash
    export MINIKUBE_ARGS="--kubernetes-version={{KUBERNETES_VERSION}} {{MINIKUBE_ARGS}}"
    minikube start ${MINIKUBE_ARGS}

# A wrapper for stopping minikube
clst-stop:
    minikube stop

# A wrapper for deleting minikube data
clst-cleanup:
    minikube delete


minikube_ip = `minikube ip || :`

# Start gateway
gateway-start:
  kubectl apply -f k8s/serverless-event-gateway.yaml

# Stop gateway
gateway-stop:
  kubectl delete -f k8s/serverless-event-gateway.yaml

# Start etcd database
etcd-start:
  kubectl apply -f k8s/etcd.yaml

# Stop etcd database
etcd-stop:
  kubectl delete -f k8s/etcd.yaml

# Check status of event gateway
check-config-status:
  #!/usr/bin/env bash
  set -v
  curl -k -v \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/status


# Register aws function for gateway 
echo-register-aws id="" arn="":
  #!/usr/bin/env bash
  set -v
  curl -k --request POST \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/functions \
    --header 'content-type: application/json' \
    --header "Host: {{minikube_ip}}.nip.io" \
    --data '{ "space": "default",
              "functionId": "{{id}}",
              "type": "awslambda",
              "provider": {
                "arn": "{{arn}}",
                "region": "us-east-1",
                "awsAccessKeyId": "{{env_var('AWS_ACCESS')}}",
                "awsSecretAccessKey": "{{env_var('AWS_SECRET')}}"}}'

# Register url function for gateway 
echo-register-any id="" url="":
  #!/usr/bin/env bash
  set -v
  curl -k --request POST \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/functions \
    --header 'content-type: application/json' \
    --header "Host: {{minikube_ip}}.nip.io" \
    --data '{ "functionId": "{{id}}",
              "type": "http",
              "provider":{"url": "{{url}}" }}'


# List all functions in gateway 
echo-list:
   curl -k --request GET \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/functions


# Trigger function
echo-trigger func="" data="":
  curl -k --request POST \
    --data '{{data}}'\
    --header "Host: {{minikube_ip}}.nip.io" \
    --header "content-type: application/json" \
    --url https://{{minikube_ip}}/serverless-event-gateway/events/{{func}}


# Delete function from gateway
echo-delete id="":
   curl -k --request DELETE \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/functions/"{{id}}"

# Create a Subscription 
sub-register id="":
  #!/usr/bin/env bash
  set -v
  curl -k --request POST \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/subscriptions \
    --header 'content-type: application/json' \
    --data '{ "type": "sync",
              "eventType": "http.request",
              "functionId": "{{id}}",
              "method": "POST",
              "path": "/{{id}}"}'

# List all subscriptions in gateway 
sub-list:
  curl -k --request GET \
   --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/subscriptions

# Delete subscription 
sub-delete +sub_id="":
  #!/bin/bash
  for i in {{sub_id}}; do
    curl -k --request DELETE \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/subscriptions/$i
  done

# Delete all subscription 
sub-delete-all:
  #!/bin/bash
  for i in $(just sub-list | python3 -c "import sys, json;[print(element['subscriptionId'], end=' ') for element in  json.load(sys.stdin)['subscriptions']]"); do
    curl -k --request DELETE \
    --url https://{{minikube_ip}}/serverless-event-gateway/config/v1/spaces/default/subscriptions/$i
  done
