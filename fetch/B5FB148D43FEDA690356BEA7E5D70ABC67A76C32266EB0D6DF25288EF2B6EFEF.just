image = "dockerhub.qingcloud.com/qingcloud/elasticsearch-sql:v1.2.6"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm --entrypoint=bash -p 8080:8080 {{image}}

push: build
  docker push {{image}}
