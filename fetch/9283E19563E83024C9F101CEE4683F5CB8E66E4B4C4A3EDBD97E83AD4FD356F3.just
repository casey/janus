default:
	cargo watch --exec test

b:
	cargo watch --clear --exec build

build:
	cargo build --release

test: 
	cargo test
