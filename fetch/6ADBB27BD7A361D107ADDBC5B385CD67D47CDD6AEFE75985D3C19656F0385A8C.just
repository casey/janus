build:
  cd policy && wasm-pack build --release
  cargo +nightly build

run: build
  cargo +nightly run
