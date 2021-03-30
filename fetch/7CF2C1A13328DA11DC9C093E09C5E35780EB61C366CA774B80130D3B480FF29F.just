export PATH := "./node_modules/.bin:" + env_var('PATH')

help:
    @just --list

build:
    mkdir -p build
    esbuild src/main.ts --bundle --outfile=build/main.js

alias b := build

watch:
    watchexec -w src -- just build

release: build
    image-resizer -f icon.png -o icon16.png -m 16
    image-resizer -f icon.png -o icon48.png -m 48
    image-resizer -f icon.png -o icon128.png -m 128
    zip artifact.zip build/main.js icon*.png manifest.json

alias w := watch
