source = "openpitrix/openpitrix:metadata"
image = "dockerhub.qingcloud.com/hevienz/metadata:v1beta1"

help:
  @just -l

pull:
  docker pull {{source}}

build: pull
  docker build -t {{image}} .

run: build
  docker run -it --rm {{image}}

push: build
  docker push {{image}}
