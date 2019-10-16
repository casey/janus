NAME := `sed -n 2p ./Cargo.toml | cut -c 8- | xargs printf`
VERSION := `sed -n 3p ./Cargo.toml | cut -c 11- | sed '1s/^/v/' | xargs printf`

build:
    cargo build --release

run:
    cargo run --release

name:
    @echo my name is {{ NAME }}

version:
    @echo version is {{ VERSION }}

docker-build:
    docker build -t nnao45/actix_web_docker .

docker-run:
    docker run --rm -it -p 8787:8787 nnao45/actix_web_docker