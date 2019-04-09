image = "dockerhub.qingcloud.com/hevienz/cerebro:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 9000:9000 {{image}}

push: build
  docker push {{image}}
