# Builds the project
build:
  cargo build

rebuild: 
  cargo clean && cargo build

build-release:
  cargo build --release

doc:
  cargo doc

open-doc: doc 
  open target/doc/rcomm/index.html