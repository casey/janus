dr = "457442207269.dkr.ecr.us-east-1.amazonaws.com/"
name = "onespot/curator"
version = "5.7.6"
uri = dr + name + ":" + version

login:
    eval $(aws ecr get-login --region us-east-1 --no-include-email)
create:
    aws ecr create-repository --repository-name "{{name}}"
build:
    docker build . -t "{{uri}}"
push: build login
    docker push "{{uri}}"
run: build
    docker run --rm -it --name curator "{{uri}}"
