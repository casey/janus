watch:
	cargo watch --clear --exec test

minimal-versions:
	cargo +nightly generate-lockfile -Z minimal-versions

install:
	cargo install --force --path .

clippy:
	cargo clippy
