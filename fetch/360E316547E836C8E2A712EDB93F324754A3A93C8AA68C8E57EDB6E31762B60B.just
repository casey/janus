default:
  cargo check --all
  cargo build --all

r:
  cargo run -- -d -t `cat priv/token`
