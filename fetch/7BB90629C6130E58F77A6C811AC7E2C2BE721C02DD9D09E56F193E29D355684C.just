DEFAULT: test

build:
    cargo build

fmt:
    cargo +nightly fmt --all -- --check

clippy:
    cargo +nightly clippy

test: fmt clippy build
    cargo +stable test

run +args="":
    cargo run -- {{args}}

