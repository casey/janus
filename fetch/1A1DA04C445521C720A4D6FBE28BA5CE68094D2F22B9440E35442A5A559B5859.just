image = "dockerhub.qingcloud.com/qingcloud/confd-ubuntu-jdk8:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm {{image}}

push: build
  docker push {{image}}
