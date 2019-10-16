help:
  @just --list


# Build image
build:
  docker build -t hello-graal .


# Run server container
run:
  @echo $(TZ=UTC gdate +"%Y-%m-%dT%T.%N") ": starting server"
  docker run --rm -i -p 8080:8080 hello-graal
