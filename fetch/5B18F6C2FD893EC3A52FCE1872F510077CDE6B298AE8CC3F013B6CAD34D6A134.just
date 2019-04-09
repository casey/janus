image = "dockerhub.qingcloud.com/qingcloud/logstash:v1.2.4"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9600:9600 {{image}}

push: build
  docker push {{image}}
