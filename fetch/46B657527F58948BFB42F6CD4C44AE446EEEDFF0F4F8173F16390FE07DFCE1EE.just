default: build

check:
  @cargo check
  @cargo +nightly clippy

build: check
  @cargo build

check_cargo_subcommand:
  @PATH=$PATH:./target/debug cargo nav --help

test_coverage:
  cargo tarpaulin -o Html

alias ccs := check_cargo_subcommand
