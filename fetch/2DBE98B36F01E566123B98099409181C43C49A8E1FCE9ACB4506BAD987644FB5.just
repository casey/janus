# The namespace is hard-coded into the following manifests:
#   - manifests/promtail.yaml
#   - manifests/prometheus.yaml
namespace := 'monitoring-system'

# List available commands.
list:
  #!/bin/bash
  set -e
  just -l

# Delete the entire namespace, including all resources and cluster-scoped RBACs.
clean: clean-configmaps
  #!/bin/bash
  set -e
  for file in $(ls "$(pwd)/manifests"); do
    kubectl -n {{namespace}} delete -f "$(pwd)/manifests/${file}" || true
  done
  kubectl delete ns {{namespace}} || true

# Removes ConfigMaps.
clean-configmaps:
  #!/bin/bash
  set -e
  for dir in $(ls "$(pwd)/configmaps"); do
    if kubectl -n {{namespace}} get cm "$dir" > /dev/null 2>&1; then
      kubectl -n {{namespace}} delete cm "$dir"
    fi
  done

# Creates ConfigMaps if they do not already exist.
configmaps:
  #!/bin/bash
  set -e
  if [[ ! $(kubectl get ns -o name) =~ 'namespace/{{namespace}}' ]]; then
    kubectl create ns {{namespace}}
  fi
  for dir in $(ls "$(pwd)/configmaps"); do
    if ! kubectl -n {{namespace}} get cm "$dir" > /dev/null 2>&1; then
      kubectl -n {{namespace}} create --save-config cm "$dir" --from-file="$(pwd)/configmaps/${dir}"
    fi
  done

# Deploys all manifests.
deploy: configmaps
  #!/bin/bash
  set -e
  if [[ ! $(kubectl get ns -o name) =~ 'namespace/{{namespace}}' ]]; then
    kubectl create ns {{namespace}}
  fi
  for file in $(ls "$(pwd)/manifests"); do
    kubectl -n {{namespace}} apply -f "$(pwd)/manifests/${file}"
  done

# Updates a ConfigMap.
update-configmap configmap:
  #!/bin/bash
  set -e
  if [[ ! -d "$(pwd)/configmaps/{{configmap}}" ]]; then
    echo 'error: configmaps/{{configmap}} does not exist.'
  else
    kubectl -n {{namespace}} create cm \
    --save-config \
    --dry-run \
    --output=yaml \
    --from-file="$(pwd)/configmaps/{{configmap}}" {{configmap}} | kubectl -n {{namespace}} apply -f-
  fi
