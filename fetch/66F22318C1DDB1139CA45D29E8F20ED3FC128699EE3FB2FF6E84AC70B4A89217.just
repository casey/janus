alias rs := run-server
alias rc := run-client
alias b := build

build:
	cargo build
run-server:
	cargo run -- --server
run-client:
	cargo run