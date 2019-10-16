run: build
  cargo run --features serverside

build: build-server build-client

build-server:
  cargo build --features serverside

build-client:
  wasm-pack build --no-typescript --target web -- --features clientside

run-release: build-release
  cargo run --features serverside

build-release: build-server-release build-client-release

build-server-release:
  cargo build --release --features serverside

build-client-release:
  wasm-pack build --release --no-typescript --target web -- --features clientside

check: check-server check-client

check-server:
  cargo check --features serverside

check-client:
  cargo check --features clientside
