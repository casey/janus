image = "hevienz/kibana:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 5601:5601 {{image}}

push: build
  docker push {{image}}
