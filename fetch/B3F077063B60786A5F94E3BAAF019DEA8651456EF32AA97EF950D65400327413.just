img:
    #!/bin/bash
    docker build . -t pg:build \
        -f Dockerfile-build
    docker build . -t pg:runtime \
        -f Dockerfile-runtime
    docker build . -t pg:3stage \
        -f Dockerfile-new \
        --build-arg pg_url=http://172.178.1.204:2015/postgresql.tar.bz2

build:
    docker build . -t pg \
        --build-arg pg_url=http://172.178.1.204:2015/postgresql.tar.bz2

test:
    docker run --rm -v $(pwd)/test.sql:/docker-entrypoint-initdb.d/test.sql pg

stage:
    docker build . -t pg-stage -f Dockerfile-stage

