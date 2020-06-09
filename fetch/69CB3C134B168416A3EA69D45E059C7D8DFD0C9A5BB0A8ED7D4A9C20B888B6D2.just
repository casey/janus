native:
  gcc hello.c -o hello.exe

node:
  emcc hello.c -o hello.js

browser:
  emcc hello.c -o index.html

inspect: node
  wasm2wat hello.wasm | less

serve: browser
  python -m SimpleHTTPServer 8080

prep:
