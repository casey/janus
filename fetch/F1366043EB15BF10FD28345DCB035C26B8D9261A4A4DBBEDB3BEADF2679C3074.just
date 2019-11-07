run:
    docker run --privileged --rm -it \
        -v $HOME/Downloads:/world \
        bud zsh

build:
    docker build . -t buildah -f Dockerfile-latest

build-test:
    docker build . -t bud -f Dockerfile-test

hello:
    docker run --privileged buildah/buildah docker run alpine:3.9 echo hello from nested podman container


bud stage:
    docker build . -t nnurphy/buildah:{{stage}} -f Dockerfile-{{stage}}

baseimg := "runc podmanbuildbase"
midimg := "podman conmon cniplugins slirp4netns fuse-overlayfs skopeo buildah"

build-base:
    #!/bin/bash
    for i in {{baseimg}}; do
        just bud $i
    done

build-mid:
    #!/bin/bash
    for i in {{midimg}}; do
        just bud $i
    done

pull:
    #!/bin/bash
    for i in {{midimg}}; do
        docker pull nnurphy/buildah:$i
    done
