image = "dockerhub.qingcloud.com/qingcloud/elasticsearch-x:v1.0"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 9200:9200 {{image}}

push: build
  docker push {{image}}
