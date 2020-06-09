dist target:
    rm -rf dist/{{target}}/*
    wasm-pack build {{target}} --no-typescript --target web
    mkdir -p dist/{{target}}
    cp -r public/{{target}}/* dist/{{target}}/
    cp {{target}}/pkg/{{target}}_bg.wasm {{target}}/pkg/{{target}}.js dist/{{target}}/

serve:
    http dist
