source = "wordpress"
image = "hevienz/wordpress"

help:
  @just -l

meta:
  docker pull openpitrix/openpitrix:metadata

pull: meta
  docker pull {{source}}

build: pull
  docker build -t {{image}} .

run: build
  docker run -it --rm  -v /opt/openpitrix:/opt/openpitrix {{image}} drone

push: build
  docker push {{image}}
