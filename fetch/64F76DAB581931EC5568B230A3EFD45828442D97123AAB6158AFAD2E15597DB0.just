checkout:
	cargo check
	cargo doc --document-private-items
	cargo build
	cargo build --example sieve
	cargo build --example tour
	cargo test
	cargo package --allow-dirty

dev:
	cargo check
	cargo test
	cargo doc --document-private-items
