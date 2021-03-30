dev:
	cargo build

release:
	cargo build --release -vv && \
	cp target/release/bamboo .

test:
	cargo test

fmt:
	cargo fmt

simple:
	cargo clippy --allow-dirty --fix -Z unstable-options

run:
	cargo run
