config_file := "$(pwd)/k8s-1-16-6-do-0-fra1-1583876329970-kubeconfig.yaml"
helm_charts_name := "kafka-cluster"
pv_count := "12"
pv_size := "10Gi"
pv_file := "volumes.json"
pv_storage_class := "do-block-storage"

_hello:
  export KUBECONFIG="{{config_file}}"
  @just -l

## KUBECTL

_kube COMMAND="get nodes":
  kubectl --kubeconfig="{{config_file}}" {{COMMAND}}

# list nodes
nodes: (_kube)
# list pods
pods: (_kube "get pods")
# describe pod
describe POD: (_kube "describe pod " + POD)

# get logs for pod
logs POD CONTAINER="": (_kube "logs " + POD + " -c " + CONTAINER)

# watch (the world burn) for k8s kafka cluster
watch:
  watch -d -n5 -x just pods

_generate_volumes:
  #!/usr/bin/env python3
  import json
  vol = '{"apiVersion":"v1","kind":"PersistentVolume","metadata":{"name":"%s","labels":{"type":"local"}},"spec":{"storageClassName":"%s","capacity":{"storage":"%s"},"accessModes":["ReadWriteOnce"],"hostPath":{"path":"%s"}}}'
  volumes = {"apiVersion": "v1", "items": [], "kind": "List", "metadata": {}}
  for i in range(0, {{pv_count}}):
    name = "data%s" % (i+1)
    volumes["items"].append(json.loads((vol % (name, "{{pv_storage_class}}" ,"{{pv_size}}", name))))
  with open("{{pv_file}}", "w+") as f:
    f.write(json.dumps(volumes, indent=2))

# generate all persistent volumes before deploy
volumes: _generate_volumes (_kube "apply -f " + pv_file)

# remove all generated pv's
clean_pv:
  just _kube "get pv -o name" | xargs -I{} kubectl delete {}

# remove all generated pvc's
clean_pvc:
  just _kube "get pvc -o name" | xargs -I{} kubectl delete {}

## HELM

alias list := helm_list
alias clean := helm_clean

# add confluent repo & help update
confluent_repo:
  helm repo add confluent https://confluentinc.github.io/cp-helm-charts/
  helm repo update

# print list of helm charts installed
helm_list:
  helm list

# clean all installed charts
helm_clean:
  helm list -q | awk '{ print $1 }' | xargs -I{} helm uninstall {}
  just clean_pvc
  just clean_pv

_helm_cmd CMD="install" HELM_CONFIG_STR="" HELM_NAME=(helm_charts_name):
  helm {{CMD}} {{HELM_CONFIG_STR}} {{HELM_NAME}} confluent/cp-helm-charts

# install my amazing custom kafka
install: confluent_repo volumes (_helm_cmd "install" "-f custom-kafka.yml" helm_charts_name)
# upgrade cluster
upgrade: (_helm_cmd "upgrade" "-f custom-kafka.yml" helm_charts_name)
