watch day part:
  cargo watch -x "build --bin d{{day}}-part{{part}}" -s "RUST_LOG=info RUST_BACKTRACE=full ./target/debug/d{{day}}-part{{part}}"
