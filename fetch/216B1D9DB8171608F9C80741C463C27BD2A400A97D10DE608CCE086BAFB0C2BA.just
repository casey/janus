default: build

build: check
  @cargo build

check:
  @cargo check
  @cargo +nightly clippy

build_release: build
  @cargo build --release
  @cp target/release/twitch_chat_to_db .
  @strip ./twitch_chat_to_db

test:
  @cargo test
