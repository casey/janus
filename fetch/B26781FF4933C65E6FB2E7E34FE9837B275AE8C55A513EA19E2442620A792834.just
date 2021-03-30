help:
  @just --list


# Build image
build-image:
  docker build -t debian-wc:10-slim .


# Run in container
run:
  docker run --rm -it debian-wc:10-slim


# Push image
push: build-image
  docker tag debian-wc:10-slim jarppe/debian-wc:10-slim
  docker push jarppe/debian-wc:10-slim
