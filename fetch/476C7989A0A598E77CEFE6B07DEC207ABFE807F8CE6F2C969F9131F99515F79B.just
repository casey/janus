export EMSCRIPTEN_DIR := "/usr/local/opt/emscripten"

build:
   mkdir -p dist
   emcc --bind -s ERROR_ON_UNDEFINED_SYMBOLS=0 --js-library library.js -O3 -o dist/a.out.js wasm-module1.cpp reactive.cpp binding.cpp

server: build
   emrun index.html

node_build:
   mkdir -p dist
   emcc --bind -s ERROR_ON_UNDEFINED_SYMBOLS=0 --js-library library.js  -O3 -s WASM=1 -Wall -s MODULARIZE=1 -o dist/a_node.js wasm-module1.cpp reactive.cpp binding.cpp

node_run: node_build
   node index.js

clean:
   rm -rf dist

generate:
  python3 {{EMSCRIPTEN_DIR}}/libexec/tools/webidl_binder.py hello.idl glue

webidl_build:
  mkdir -p dist
  emcc -std=c++1y -O3 hello.cpp glue_wrapper.cpp --post-js glue.js -o dist/hello.js

