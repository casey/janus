#!/usr/bin/env just --justfile

build:
    stack build
    clang -c gc.c

install-dev-deps:
    stack --install-ghc test --only-dependencies
    stack build hlint

@run:
    # to link without clang:
    # ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o -lc gen.o /usr/lib/x86_64-linux-gnu/crtn.o
    stack run -- "$@" > gen.ll && llc-9 -filetype=asm -O2 gen.ll && clang -c gc.c && clang gen.s gc.o -o gen.out && ./gen.out

test:
    stack test

lint:
    stack exec hlint -- app src test

check: test lint

push: check
    # don't push to master
    # ! git branch | grep '* master'
    git push

# Development

ghcid:
    stack exec -- ghcid --command='stack ghci'

interactive-test:
    stack exec -- ghcid --command='stack ghci --test --main-is llvm-lambda:test:llvm-lambda-test' --run

