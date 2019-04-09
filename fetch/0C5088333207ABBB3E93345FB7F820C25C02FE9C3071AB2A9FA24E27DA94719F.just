watch:
    watchexec -w src --clear --exts rs 'rustc --target wasm32-unknown-unknown -O --crate-type=cdylib src/lib.rs -o target/lib.big.wasm && wasm-gc target/lib.big.wasm target/lib.wasm'

serve:
    python3 -m http.server 8002 --bind 127.0.0.1
