
set shell := ["powershell"]

r:
    cargo run

rr:
    cargo run --release

c:
    cargo check

cc:
    cargo check
    cargo test --no-run --all-targets

ccc:
    cargo clean
    cargo clippy
    cargo build

t:
    cargo test

do:
    cargo doc --no-deps --open
