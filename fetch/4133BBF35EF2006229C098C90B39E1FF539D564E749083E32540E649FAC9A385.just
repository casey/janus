image = "dockerhub.qingcloud.com/hevienz/elasticsearch-sql:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 8080:8080 {{image}}

push: build
  docker push {{image}}
