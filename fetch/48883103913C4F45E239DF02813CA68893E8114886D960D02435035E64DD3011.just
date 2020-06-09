version = "6.8.1-os.4"
dr = "457442207269.dkr.ecr.us-east-1.amazonaws.com/"
es_name = "onespot/elasticsearch"
es_uri = dr + es_name + ":" + version
ls_name = "onespot/logstash"
ls_uri = dr + ls_name + ":" + version

create-es:
    aws ecr create-repository --repository-name "{{es_name}}"
create-ls:
    aws ecr create-repository --repository-name "{{ls_name}}"

run-es: build-es
    docker run --rm -it --entrypoint bash "{{es_uri}}"
run-ls: build-ls
    docker run --rm -it --entrypoint bash "{{ls_uri}}"

login:
    eval $(aws ecr get-login --region us-east-1 --no-include-email)
build-es:
    docker build -f Dockerfile.elasticsearch -t "{{es_uri}}" .
push-es: login build-es
    docker push "{{es_uri}}"
build-ls:
    docker build -f Dockerfile.logstash -t "{{ls_uri}}" .
push-ls: login build-ls
    docker push "{{ls_uri}}"

build: build-es build-ls
push: build login push-es push-ls
