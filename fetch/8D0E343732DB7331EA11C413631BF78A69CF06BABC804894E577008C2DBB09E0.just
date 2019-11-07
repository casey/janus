serve:
    ng s -o

build:
    cd wasm-worker; wasm-pack build --release --target no-modules
