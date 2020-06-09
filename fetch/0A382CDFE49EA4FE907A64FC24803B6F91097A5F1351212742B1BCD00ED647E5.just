build:
    docker run -it -v $PWD:/volume --rm $(docker build -q .) cargo build --release

run:
    sudo target/x86_64-unknown-linux-musl/release/devils-fingers

