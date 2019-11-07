build: fmt wasm ts

run:
    python3 x.py

wasm:
    rm dist/*.wasm || echo 0
    cd crate; wasm-pack build; cd ..
    npx webpack

ts:
    cd src/ts; tsc *.ts --outDir ..; cd ../..
    npx webpack

fmt: 
    cargo fmt