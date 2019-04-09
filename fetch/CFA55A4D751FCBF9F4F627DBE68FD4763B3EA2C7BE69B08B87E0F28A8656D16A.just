image = "dockerhub.qingcloud.com/qingcloud/elasticsearch:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9200:9200 --privileged {{image}}

push: build
  docker push {{image}}
