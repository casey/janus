ci: setup check lint test

setup:
  yarn

check:
  flow

test:
  jest

lint:
  eslint $(fd jsx src)
  prettier --check $(fd jsx src)

lint-fix:
  eslint $(fd jsx src) --fix
  prettier --write $(fd jsx src)

serve:
  parcel src/index.html --no-hmr

deploy-to-docs: ci
  rm -rf docs
  parcel build \
    --public-url https://soenkehahn.github.io/nano/ \
    --no-source-maps \
    --out-dir docs \
    src/index.html
