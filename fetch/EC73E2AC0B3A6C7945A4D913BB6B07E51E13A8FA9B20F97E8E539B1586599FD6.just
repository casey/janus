fetch:
  pip3 install wasmer
  cp ../my_lib/pkg/my_lib_bg.wasm my_lib.wasm

run: fetch
  python3 main.py

prep: fetch
