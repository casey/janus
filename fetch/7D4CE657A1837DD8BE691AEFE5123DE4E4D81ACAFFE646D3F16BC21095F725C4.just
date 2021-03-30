lint:
    autoflake --remove-all-unused-imports --recursive --remove-unused-variables --in-place .
    cd ./poif && isort --profile black --line-length 119 .
    cd ./poif && black --line-length 119 .
    -cd ./poif && mypy --ignore-missing-imports .

test:
    cd ./poif && pytest .

@generate_doc:
    rm -f -r ./docs
    cd ./poif && pdoc --html -c show_type_annotations=True --force poif --html-dir ./../pdoc
    mv ./pdoc/poif ./docs
    rm -r ./pdoc


check: lint test generate_doc


setup-test-minio:
    python ./poif/poif/tests/integration/minio/setup.py

setup-test-gitlab:
    python ./poif/poif/tests/integration/gitlab/setup.py

setup-test-environment: setup-test-minio setup-test-gitlab


get-repo:
    python ./poif/poif/tests/gitlab/get_repo.py

sort:
    cd poif && isort .

# K3S commands

uninstall-k3s:
    /usr/local/bin/k3s-uninstall.sh

install-k3s:
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644  --disable-network-policy --docker

install-aws-cli:
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
