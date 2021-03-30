all: push

push: build
    docker push docker.fau.xxx/public/unreal

build:
    DOCKER_BUILDKIT=1 docker build . -t docker.fau.xxx/public/unreal
