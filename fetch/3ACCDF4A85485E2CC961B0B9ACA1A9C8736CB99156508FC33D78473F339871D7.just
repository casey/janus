@bindings:
    util/bindgen.sh

@build:
    cargo build
    util/assemble_image.sh

@flash: build
    util/flash.sh

@open: flash
    screen /dev/ttyACM1 115200

rustup:
    rustup toolchain add nightly
    rustup target add x86_64-unknown-linux-gnu
    rustup target add thumbv8m.main-none-eabihf
    rustup default nightly-x86_64-unknown-linux-gnu

# 'sh' and 'yarn serve' are most useful args
vue +args:
    docker run --rm -it \
        -v $PWD/web:/work \
        -u 1000:1000 \
        --net host \
        -w /work \
        --entrypoint '' \
        $(docker build -q -f util/vue.dockerfile web/) {{args}}
