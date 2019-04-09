image = "dockerhub.qingcloud.com/hevienz/elastichd:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 9800:9800 {{image}}

push: build
  docker push {{image}}
