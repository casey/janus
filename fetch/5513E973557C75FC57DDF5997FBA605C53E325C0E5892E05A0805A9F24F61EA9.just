build:
	cargo check
	cargo build

publish: build
	cargo publish
	rm -r target/
