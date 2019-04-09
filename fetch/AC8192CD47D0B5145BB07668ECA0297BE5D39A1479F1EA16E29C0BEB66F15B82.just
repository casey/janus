export RUST_BACKTRACE="1"
export RUST_LOG="othello-server=DEBUG,actix=INFO"

dev: debug-client start-server

start-server:
    cargo run -p othello-server

debug-client:
    cargo +nightly web build --target wasm32-unknown-unknown -p othello-client --release
    cp target/wasm32-unknown-unknown/release/othello-client.js static
    cp target/wasm32-unknown-unknown/release/othello-client.wasm static

dist:
    # Ensure we have a clean dist directory
    mkdir -p dist
    rm -rf dist/*
    mkdir -p dist/static

    # Copy static
    cp static/index.html dist/static/index.html
    cp static/index.css dist/static/index.css
    # Build the server
    cargo build -p othello-server --release

    # Build the client
    cargo +nightly web build --target wasm32-unknown-unknown -p othello-client --release

    # Copy released file
    cp target/release/othello-server dist
    cp target/wasm32-unknown-unknown/release/othello-client.js dist/static 
    cp target/wasm32-unknown-unknown/release/othello-client.wasm dist/static

