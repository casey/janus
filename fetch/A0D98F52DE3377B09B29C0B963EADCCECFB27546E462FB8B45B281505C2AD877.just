format:
  cargo fmt --all

lint:
  cargo clippy

test:
  cargo test

build:
  cargo build --release

all: format lint test build
