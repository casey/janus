run: build
  cargo run --features serverside

build:
  cargo build --features serverside
  wasm-pack build --no-typescript --target web -- --features clientside
