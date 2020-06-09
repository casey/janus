build:
    docker pull clux/muslrust
    docker run -v $PWD:/volume --rm -t clux/muslrust cargo build
build-release:
    docker pull clux/muslrust
    docker run -v $PWD:/volume --rm -t clux/muslrust cargo build --release