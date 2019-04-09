build:
    cargo build

test:
    cargo test

test-debug:
    RUST_LOG=debug

test-int:
    cargo test --no-default-features --features integration

test-mine:
     cargo test --no-default-features --features mining-tests

run env='dev':
    ROCKET_ENV={{env}} RUST_LOG=info cargo run