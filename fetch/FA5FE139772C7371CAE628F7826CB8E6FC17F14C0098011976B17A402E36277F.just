project_name := "yew_min_wbg"

build:
    cargo build --target wasm32-unknown-unknown
    mkdir -p "dist/wasm"
    wasm-bindgen "target/wasm32-unknown-unknown/debug/{{project_name}}.wasm" \
    --out-name "{{project_name}}" \
    --target web \
    --no-typescript \
    --out-dir "dist/wasm"
    cp -afu "static/." "dist"

clean:
    rm -rf "dist" "target"

serve: build
    simple-http-server --index --nocache --try-file "dist/index.html" -p 8000 "dist"

watch:
    watchexec -c -n -i dist -i target -e html,js,rs,css,scss -r just serve
