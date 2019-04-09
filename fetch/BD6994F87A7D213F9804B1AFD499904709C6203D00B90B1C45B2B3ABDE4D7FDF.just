deploy host:
    cargo build --release && scp target/release/melt {{host}}:~/.
