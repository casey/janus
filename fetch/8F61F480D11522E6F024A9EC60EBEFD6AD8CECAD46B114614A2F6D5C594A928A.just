all: push

push: build
    docker push docker.fau.xxx/public/quad-image

build:
    DOCKER_BUILDKIT=1 docker build . -t docker.fau.xxx/public/quad-image
