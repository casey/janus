docker:
    docker build -t menmos/menmosd --target menmosd .
    docker build -t menmos/amphora --target amphora .

lint:
    rm -rf target
    cargo check
    cargo clippy

unit +args="":
    cargo test --workspace --lib {{args}}

integration +args="":
    cargo test --workspace --test '*'

test:
    @just lint
    @just unit
    @just integration
