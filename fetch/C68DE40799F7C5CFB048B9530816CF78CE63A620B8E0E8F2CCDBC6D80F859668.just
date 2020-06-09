
start:
  cargo web start

check:
  cargo check

recheck:
  cargo watch -x check

run:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo run

release:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo run --release

build:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo build

debug-build:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo build

debug-run:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo run

rerun:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo watch -x run

test:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo test

retest:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo watch -x test

sizes:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld -Z print-type-sizes" cargo +nightly build

debug:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" RUST_BACKTRACE=1 cargo run

flame:
  RUSTFLAGS="-C link-arg=-fuse-ld=lld" cargo flamegraph
