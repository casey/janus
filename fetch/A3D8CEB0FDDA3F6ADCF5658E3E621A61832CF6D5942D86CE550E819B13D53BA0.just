env = "RUST_LOG=INFO"

help:
  @just -l


build:
  cargo build


run: build
  {{env}} ./target/debug/tokio_test


fmt:
  cargo fmt
