test-cli:
    cargo test --all cli -- --test-threads=8

pr: pr-fmt pr-test pr-clippy

pr-test:
    cargo test --all

pr-fmt:
    cargo fmt --all

pr-clippy:
    cargo clippy --all -- -D clippy::pedantic -D clippy::nursery
