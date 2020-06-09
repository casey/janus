dr = "457442207269.dkr.ecr.us-east-1.amazonaws.com/"
name = "teamcity-agent"
version = "2019.1.2-os.8"
uri = dr + "onespot/" + name + ":" + version

login:
    eval $(aws ecr get-login --region us-east-1 --no-include-email)
create:
    aws ecr create-repository --repository-name "onespot/{{name}}"
build:
    docker build . -t "{{uri}}"
push: build login
    docker push "{{uri}}"
run: build
    docker run --rm -it --name "{{name}}"\
     --entrypoint bash\
     "{{uri}}"
