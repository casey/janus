set shell := ["powershell.exe", "-c"]

build:
    docker-compose build \
        --force-rm \
        --build-arg DOMAIN=$env:DOMAIN \
        --build-arg HOSTNAME=$env:HOSTNAME \
        smtp

console:
    docker-compose run --rm smtp bash

run:
    docker-compose up smtp