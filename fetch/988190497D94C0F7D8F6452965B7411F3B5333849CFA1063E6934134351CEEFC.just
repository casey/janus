
all:
    cargo build --target armv7-unknown-linux-gnueabihf --release

clean:
    cargo clean

setup:
    docker build -t rust-dev .

build:
    docker run --rm -it -v ${PWD}:/usr/src/code -v ${PWD}/.cargo:/usr/local/cargo/registry/cache/ rust-dev bash -c "just all"
    docker run --rm -it -v ${PWD}:/usr/src/code -v ${PWD}/.cargo:/usr/local/cargo/registry/cache/ rust-dev bash -c "arm-linux-gnueabihf-gcc -o target/pam_test test.c -lpam -lpam_misc"

test:
    docker run --rm -it \
    -v ${PWD}:/usr/src/code \
    -v ${PWD}/conf/config.json:/mnt/boot/config.json \
    -v ${PWD}/conf/jwt-auth:/etc/pam.d/jwt-auth \
    -v ${PWD}/target/armv7-unknown-linux-gnueabihf/release/libpam_jwt.so:/lib/arm-linux-gnueabihf/security/pam_jwt.so \
    resin/armv7hf-debian:stretch bash -c "/usr/src/code/target/pam_test pi"