build:
    cargo update
    rm docs/*.wasm || echo 0
    cd crate; cargo update; wasm-pack build; cd ..
    npm install
    npx webpack