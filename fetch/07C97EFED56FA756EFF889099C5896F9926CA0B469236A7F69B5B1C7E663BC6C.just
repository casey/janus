image = "hevienz/logstash:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 9600:9600 {{image}}

push: build
  docker push {{image}}
