build:
    cargo +nightly build --target wasm32-unknown-unknown --release
    mkdir -p build
    wasm-opt -Oz -o ./build/askalono.wasm-tmp ./target/wasm32-unknown-unknown/release/askalono_wasm.wasm
    wasm-bindgen ./build/askalono.wasm-tmp --out-dir ./build
