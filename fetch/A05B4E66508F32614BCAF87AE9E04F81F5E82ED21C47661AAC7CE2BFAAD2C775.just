build:
  cargo web deploy --release

_quiet-build:
  @cargo web deploy --release > /dev/null

inspect: _quiet-build
  wasm2wat target/deploy/stack-machine.wasm | less

serve: _quiet-build
  cargo web start --release --port=8080

prep: build
