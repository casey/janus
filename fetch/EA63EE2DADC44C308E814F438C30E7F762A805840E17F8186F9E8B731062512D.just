dev:
  parcel src/index.html

bundle:
  parcel build src/index.html

deploy: ci
  rm -rf docs
  parcel build \
    --public-url https://soenkehahn.github.io/write-a-page/ \
    --no-source-maps \
    --out-dir docs \
    src/index.html

setup:
  yarn install

type-check:
  flow

test:
  jest

format-check:
  prettier --check src/*
  prettier --check src/**/*

ci: setup type-check test format-check bundle
