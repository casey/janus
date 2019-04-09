default:
	cargo test

build:
	cargo build

run-file: build
	#!./target/debug/forth
	7 70 + .
	8 80 + .