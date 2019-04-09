test:
    cargo test
lint:
    cargo clippy
build:
    cargo build
run:
    cargo run
ci:
    just test && just lint
