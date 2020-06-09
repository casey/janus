tour:
  @cat src/lib.rs

build:
  wasm-pack build --release --target=nodejs

_quiet-build:
  wasm-pack build --release --target=nodejs 2> /dev/null

inspect: _quiet-build
  wasm2wat pkg/time_bg.wasm | less

test: _quiet-build
  node test.js

prep: build
