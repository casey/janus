run bin='hello_world':
    cargo run --bin {{bin}}

run-web bin='hello_world':
    cargo build --bin {{bin}} --target wasm32-unknown-unknown
    wasm-bindgen --out-dir target/wasm/{{bin}} --target web target/wasm32-unknown-unknown/debug/{{bin}}.wasm
    cp wasm_resources/index.tpl.html target/wasm/{{bin}}/index.html
    sed -i s/\$bin/{{bin}}/ target/wasm/{{bin}}/index.html
    ln -fs ../../../assets target/wasm/{{bin}}
    basic-http-server target/wasm/{{bin}}