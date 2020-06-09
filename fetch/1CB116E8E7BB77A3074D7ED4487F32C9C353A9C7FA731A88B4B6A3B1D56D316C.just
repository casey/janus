tour:
  @cat src/lib.rs

build:
  cargo build --release --target=wasm32-unknown-unknown

inspect: build
  wasm2wat target/wasm32-unknown-unknown/release/*.wasm | less
