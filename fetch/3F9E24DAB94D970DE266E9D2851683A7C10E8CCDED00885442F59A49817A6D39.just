image = "hevienz/elasticsearch:v1beta1"

help:
  @just -l

build:
  docker build -t {{image}} .

run: build
  docker run -it --rm -p 9200:9200 --privileged {{image}}

push: build
  docker push {{image}}
