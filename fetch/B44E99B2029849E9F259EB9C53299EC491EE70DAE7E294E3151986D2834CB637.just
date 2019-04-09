source = "mysql:5.6"
image = "hevienz/mysql"

help:
  @just -l

meta:
  docker pull openpitrix/openpitrix:metadata

pull: meta
  docker pull {{source}}

build: pull
  docker build -t {{image}} .

run: build
  docker run -it --rm -v /opt/openpitrix:/opt/openpitrix {{image}} sh

push: build
  docker push {{image}}
