build:
    cargo build --target wasm32-unknown-emscripten --release
    cd site/
    python -m SimpleHTTPServer    

setup:
    mkdir site/
    cp target/wasm32-unknown-emscripten/release/marc.js site/
    cp target/wasm32-unknown-emscripten/release/marc.wasm site/    

pre:
    rustup override set nightly
    rustup add wasm32-unknown-emscripten
