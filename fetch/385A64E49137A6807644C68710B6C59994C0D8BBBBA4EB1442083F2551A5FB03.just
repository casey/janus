# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :

# List available recipes
default:
  @just --list

build:
  cargo build

start:
  cargo watch -x 'run --bin api'

run:
  cargo run --bin api

test:
  just unit integration

unit:
  cargo test --lib

integration:
  cargo test --test integration

watch:
  cargo watch
