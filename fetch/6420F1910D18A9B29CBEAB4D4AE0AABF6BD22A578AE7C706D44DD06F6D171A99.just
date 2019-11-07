default: 
    cargo watch --clear --exec test

check: 
    cargo watch --clear --exec check

run: 
    cargo watch --clear --exec run

build: 
	cargo build --release

log: 
	cargo test -- --nocapture

publish:
	cargo build
	cargo publish
