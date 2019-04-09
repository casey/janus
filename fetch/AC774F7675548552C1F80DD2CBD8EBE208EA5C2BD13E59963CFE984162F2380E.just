image = "dockerhub.qingcloud.com/qingcloud/kibana:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 5601:5601 {{image}}

push: build
  docker push {{image}}
