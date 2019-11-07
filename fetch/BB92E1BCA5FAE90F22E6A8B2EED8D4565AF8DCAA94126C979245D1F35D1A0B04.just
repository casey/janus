# This `justfile` should allow you to run a debug build of `falconeri`
# on a minikube cluster.
#
# You can find the input data in `texts`.

# Start a local copy of minikube.
minikube:
    minikube start
    @echo "Now run `eval $(minikube docker-env)`"

# Build our image.
image:
    cp ../../bin/debug/falconeri-worker .
    docker build -t word-frequencies .

# Create a secret using credentials from a vault server, if you have one.
secret:
    #!/usr/bin/env bash
    set -euo pipefail

    # Fetch creds.
    vault read -format=json aws/creds/falconeri-test > creds.json
    cat creds.json | jq -jr '.data.access_key' > AWS_ACCESS_KEY_ID
    cat creds.json | jq -jr '.data.secret_key' > AWS_SECRET_ACCESS_KEY
    rm creds.json

    # Create secret.
    kubectl delete secret/s3 || true
    kubectl create secret generic s3 \
        --from-file=AWS_ACCESS_KEY_ID \
        --from-file=AWS_SECRET_ACCESS_KEY
    rm AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

# Run our example job.
run:
    cargo run -p falconeri -- job run word-frequencies.json
