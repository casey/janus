musl-docker:
    docker run \
        -v cargo-cache:/root/.cargo/registry \
        -v "$PWD:/volume" \
        --rm \
        -it clux/muslrust \
        sh -c 'cd stricter-worker && RUSTFLAGS=-Ctarget-cpu=generic cargo build --release'
