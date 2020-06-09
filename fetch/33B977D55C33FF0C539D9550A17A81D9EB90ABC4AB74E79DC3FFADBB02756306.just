native:
  go build -o hello.exe

node:
  GOOS=js GOARCH=wasm go build -o hello.wasm

inspect: node
  wasm2wat hello.wasm | less -p runtime.typestring

run: node
  node $(go env GOROOT)/misc/wasm/wasm_exec.js hello.wasm

prep:
