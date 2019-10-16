build +ARGS='':
  @OPENSSL_LIB_DIR=/usr/lib/openssl-1.0/ OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0/ cargo build {{ARGS}}

test +ARGS='':
  @OPENSSL_LIB_DIR=/usr/lib/openssl-1.0/ OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0/ cargo test --lib {{ARGS}}

bench +ARGS='':
  @OPENSSL_LIB_DIR=/usr/lib/openssl-1.0/ OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0/ cargo bench --features bench --lib {{ARGS}}

build22:
  @OPENSSL_LIB_DIR=/usr/lib/openssl-1.0/ OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0/ rustup run 1.22.1 cargo build

test22:
  @OPENSSL_LIB_DIR=/usr/lib/openssl-1.0/ OPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0/ rustup run 1.22.1 cargo test

fetch day:
  @target/fetchdata {{day}}

run puzzle file='':
  @just build
  @target/debug/aoc {{puzzle}} {{file}}

relrun puzzle file='':
  @just build --release
  @target/release/aoc {{puzzle}} {{file}}

version:
  cargo version
