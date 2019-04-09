image = "dockerhub.qingcloud.com/qingcloud/cerebro:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9000:9000 {{image}}

push: build
  docker push {{image}}
