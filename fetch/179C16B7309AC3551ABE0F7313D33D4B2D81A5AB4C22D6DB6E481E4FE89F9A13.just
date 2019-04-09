default: test

test:
	RUST_BACKTRACE=1 cargo test

publish:
	cargo publish
