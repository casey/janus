image = "dockerhub.qingcloud.com/qingcloud/elastichd:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9800:9800 {{image}}

push: build
  docker push {{image}}
