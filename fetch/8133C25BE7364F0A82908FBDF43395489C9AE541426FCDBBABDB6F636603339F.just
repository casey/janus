ci:
  cargo test
  cargo clippy
  cargo fmt -- --check
