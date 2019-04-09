setup:
    rustup toolchain install nightly
    RUSTFLAGS="--cfg procmacro2_semver_exempt" cargo install cargo-tarpaulin
    rustup component add rustfmt-preview
    rustup component add clippy-preview
lint:
    cargo fmt
    cargo clippy

test: lint
    cargo +nightly tarpaulin
