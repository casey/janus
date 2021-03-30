default: build

check:
	@cargo check
	@cargo +nightly clippy

build: check
	@cargo build

br: check
	@cargo build --release
