build:
    cargo build --release --target wasm32-unknown-unknown
    chisel target/wasm32-unknown-unknown/release/sentinel_rs.wasm target/wasm32-unknown-unknown/release/sentinel_rs.wasm
