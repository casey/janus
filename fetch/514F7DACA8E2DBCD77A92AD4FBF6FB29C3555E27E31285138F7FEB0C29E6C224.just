default: fmt lint build
	
build:
	cargo build

fmt:
	cargo fmt

lint:
	cargo clippy
