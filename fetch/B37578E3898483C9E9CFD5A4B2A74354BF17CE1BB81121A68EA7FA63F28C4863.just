LIB := "gmp-6.2.0"

extract:
  #!/usr/bin/env bash
  if [[ ! -d {{LIB}} ]]; then
    tar xf {{LIB}}.tar.lz
    cd {{LIB}}
    emconfigure ./configure --enable-cxx --host=none 
  fi

build: build-gmp
  emcc hello.c {{LIB}}/.libs/libgmp.a -I {{LIB}}
  emcc hello.c {{LIB}}/.libs/libgmp.a -I {{LIB}} -o index.html

build-gmp:
  cd {{LIB}} && make

test:
  echo 999988 | node a.out.js

serve:
  #!/usr/bin/env python3
  from http.server import HTTPServer, SimpleHTTPRequestHandler
  class Handler(SimpleHTTPRequestHandler):
    pass
  Handler.extensions_map[".wasm"] = "application/wasm"
  print("listening on port 8000...")
  HTTPServer(('', 8000), Handler).serve_forever()
