build:
    #!/bin/bash
    npx esbuild src/lib.ts --bundle \
        --outfile=dist/lib.js \
        --format=cjs \
        --loader:.frag=text \
        --loader:.vert=text

build-demo:
    #!/bin/bash
    (cd demo && npm install)
    (cd demo && npx esbuild demo.ts --bundle --outfile=dist/demo.js --loader:.png=file)
    cp demo/index.html demo/dist/index.html

build-all: build build-demo

serve-demo: build-all
    (cd demo/dist && http)
