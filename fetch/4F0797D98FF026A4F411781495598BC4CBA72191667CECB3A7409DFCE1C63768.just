fetch-local:
    cargo build --release && target/release/cli fetch --year 2019 --target-dir data
