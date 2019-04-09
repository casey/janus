clean:
    cargo clean

fmt:
    cargo fmt --all

lint:
    cargo fmt --all -- --check

build:
    cargo build

build-release:
    cargo build --release

test:
    cargo test

bench:
    cargo bench
