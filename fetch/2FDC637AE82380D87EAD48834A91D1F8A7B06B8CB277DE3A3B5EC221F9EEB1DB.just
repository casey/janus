build:
  docker run \
    --rm \
    -it \
    -v $PWD:/volume \
    -v cargo-cache:/root/.cargo \
    clux/muslrust:nightly \
    cargo build --release --out-dir /volume/bin -Z unstable-options
