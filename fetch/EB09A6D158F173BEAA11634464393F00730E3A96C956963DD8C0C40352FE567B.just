build:
	cargo check
	cargo build

doc: test
	cargo doc

publish: doc
	# Publish derive first, since this depends on it
	just endian_trait_derive/publish
	cargo publish

test: build
	cargo test --features arrays
	cargo +nightly test --features arrays,e128
