tour:
  @cat src/lib.rs

build:
  wasm-pack build --release

_quiet-build:
  wasm-pack build --release 2> /dev/null

inspect: _quiet-build
  wasm2wat pkg/add_bg.wasm

test: _quiet-build
  node test.js

prep: build
