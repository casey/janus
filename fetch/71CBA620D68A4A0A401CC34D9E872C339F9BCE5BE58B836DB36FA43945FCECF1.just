image = "dockerhub.qingcloud.com/hevienz/metadata-ubuntu-jdk8:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --privileged {{image}}

push: build
  docker push {{image}}
