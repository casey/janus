run:
    cargo +nightly run

build:
    cargo +nightly build

build-release:
    cargo +nightly build --release && strip target/release/spa-host
    cargo +nightly build --release --target=x86_64-pc-windows-gnu
