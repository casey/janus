build-examples:
    cd examples/echo && cargo build --target wasm32-unknown-unknown
    cd ../..
