image = "dockerhub.qingcloud.com/hevienz/elasticsearch-head:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 9100:9100 {{image}}

push: build
  docker push {{image}}
