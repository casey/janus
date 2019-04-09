default:
	cargo watch --clear --exec build

t:
	cargo watch --exec test

build:
	cargo build --release

test: 
	cargo test
