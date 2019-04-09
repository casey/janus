image = "dockerhub.qingcloud.com/qingcloud/elasticsearch-head:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9100:9100 {{image}}

push: build
  docker push {{image}}
