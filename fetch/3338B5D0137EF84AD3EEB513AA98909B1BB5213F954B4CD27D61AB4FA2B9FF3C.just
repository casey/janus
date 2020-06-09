build:
  wasm-pack build --release --target=web

_quiet-build:
  wasm-pack build --release --target=web 2> /dev/null

inspect: _quiet-build
  wasm2wat pkg/dom_bg.wasm | less

test:
  cargo test

serve: _quiet-build
  python -m SimpleHTTPServer 8080

prep: build
