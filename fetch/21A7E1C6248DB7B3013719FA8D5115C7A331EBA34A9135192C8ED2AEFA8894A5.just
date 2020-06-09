export CGO_ENABLED := "1"
export CC := "gcc"

fetch:
  go get github.com/wasmerio/go-ext-wasm/wasmer
  cp ../my_lib/pkg/my_lib_bg.wasm my_lib.wasm

build: fetch
  go build -o main.exe

run: build
  ./main.exe

prep: build
