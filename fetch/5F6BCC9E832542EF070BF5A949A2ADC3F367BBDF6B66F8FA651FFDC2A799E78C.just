fetch:
  cp ../my_lib/pkg/my_lib_bg.wasm my_lib.wasm

build: fetch
  cargo build --release

run: build
  ./target/release/embed-wasm

prep: build
