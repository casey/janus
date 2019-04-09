source = "openpitrix/openpitrix:metadata"
image = "dockerhub.qingcloud.com/hevienz/metadata-ubuntu:v1beta1"

help:
  @just -l

pull:
  docker pull {{source}}

build: pull
  docker build -t {{image}} .

run: build
  docker run -it --rm --privileged {{image}}

push: build
  docker push {{image}}
