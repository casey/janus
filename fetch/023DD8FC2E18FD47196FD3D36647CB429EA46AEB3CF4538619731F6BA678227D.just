run:
    cargo run --release

console:
    cargo run --no-default-features --features console

test:
    cargo clippy
    cargo test

c:
    cargo fmt
    cargo update

    cargo clippy
    cargo c

    cargo doc
    cargo build

    cargo test