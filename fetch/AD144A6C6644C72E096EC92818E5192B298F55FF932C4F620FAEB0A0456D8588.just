default: test

test:
	cargo test

watch:
	cargo watch -x check

life:
	cd examples/life && cargo run --release
