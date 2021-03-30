_:
  @just --list

# example log
log:
  cargo run --example log

# publish
publish:
  cargo publish

# test all
test:
  cargo test
  cd demo/test_clap; cargo build; cargo test

