build: build-x86_64

build-aarch64:
    CC=aarch64-linux-gnu-musl-gcc cargo rustc --release --target aarch64-unknown-linux-musl --verbose -- -C linker=aarch64-linux-gnu-musl-gcc -C link-arg=-lgcc
build-x86_64:
    CC=musl-gcc cargo rustc --release --target x86_64-unknown-linux-musl --verbose -- -C linker=musl-gcc -C link-arg=-lgcc