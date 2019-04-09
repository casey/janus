env = "RUST_LOG=INFO"

help:
  @just -l


build:
  cargo build


run: build
  {{env}} ./target/debug/sshr 192.168.0.12


fmt:
  cargo fmt
