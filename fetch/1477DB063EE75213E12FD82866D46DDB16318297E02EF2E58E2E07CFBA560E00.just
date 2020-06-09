help:
  @just --help


build:
  docker build -t hello-go-rest:latest .


run:
   docker run --rm -i -p 9000:8000 hello-go-rest:latest
