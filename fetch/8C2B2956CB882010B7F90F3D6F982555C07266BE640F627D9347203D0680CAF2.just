run_server: build
  npm run serve

build:
  cargo build
  npm run build

clean:
  cargo clean
  rm -rf pkg
  rm -rf dist