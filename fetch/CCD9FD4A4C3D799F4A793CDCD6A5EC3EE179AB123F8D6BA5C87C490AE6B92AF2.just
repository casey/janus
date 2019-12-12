package_dir := "package"

_list:
    just --list

@package:
    cargo build --release
    mkdir -p {{package_dir}}
    cp ./target/release/repo.exe {{package_dir}}/

@fmt:
    cargo +nightly fmt

@install:
    cargo install --path . --force

@clip:
    cargo clippy -- -Dwarnings
