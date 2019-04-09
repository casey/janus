default:
    cargo build --target wasm32-unknown-unknown 
bindgen: default
    wasm-bindgen --no-modules target/wasm32-unknown-unknown/debug/no_modules.wasm --out-dir .
serve: bindgen
    devd -olp 3333 .
