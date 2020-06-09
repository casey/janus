image_name = "onespot/recommending-elasticdump"
uri = "457442207269.dkr.ecr.us-east-1.amazonaws.com/onespot/recommending-elasticdump"

create:
    aws ecr create-repository --repository-name "{{image_name}}"
find-uri:
    aws ecr describe-repositories --repository-names "{{image_name}}" | jq -r .repositories[].repositoryUri
build:
    docker build . -t "{{uri}}"
run: build
    docker run --rm -it\
     --volume ~/.aws/credentials:/root/.aws/credentials\
     --entrypoint bash\
     "{{uri}}"
login:
    eval $(aws ecr get-login --region us-east-1 --no-include-email)
push: build login
    docker push "{{uri}}"
deploy: push
    #!/bin/bash
    FQN=$(docker inspect --format='{{'{{ index .RepoDigests 0 }}'}}' '{{ uri }}')
    DIGEST="${FQN#*@}"
    echo "found digest of ${DIGEST}"
    for f in *.nomad.hcl; do
        cat "${f}" | sed "s/IMAGE_DIGEST/${DIGEST}/" | nomad run -
    done
