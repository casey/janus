check: 
    cargo watch --clear --exec check

test: 
    cargo watch --clear --exec test

build: 
	cargo build --release

run: 
	cargo run --release

publish:
	cargo build
	cargo publish
