help:
  @just --list


build:
  docker build -t distroless-go .


run:
  docker run --rm -p 8080:8080 distroless-go


ls:
  docker image ls | grep distroless-go
