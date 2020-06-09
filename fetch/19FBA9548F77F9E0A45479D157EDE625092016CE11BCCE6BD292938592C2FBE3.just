run:
    cargo run --release

c:
    cargo fmt
    cargo update

    cargo clippy
    cargo c

    cargo doc
    cargo build

    cargo test