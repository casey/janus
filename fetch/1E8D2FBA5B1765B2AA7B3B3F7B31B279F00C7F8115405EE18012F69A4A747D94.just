default: build

build: check
  @cargo build

check:
  @cargo check
  @cargo +nightly clippy

build_release: build
  @cargo build --release
  @cp target/release/jumpto .
  @strip ./jumpto

test:
  @cargo test
