test:
    cargo test
lint:
    cargo clippy
ci:
    just test && just lint
build:
    cargo build && docker-compose build
run:
    docker-compose up
start:
    just build && just run
