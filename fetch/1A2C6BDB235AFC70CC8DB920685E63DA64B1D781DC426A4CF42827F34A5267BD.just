tour:
  @cat src/lib.rs

build:
  wasm-pack build --release

_quiet-build:
  wasm-pack build --release 2> /dev/null

inspect: _quiet-build
  wasm2wat pkg/my_lib_bg.wasm | less

prep: build
