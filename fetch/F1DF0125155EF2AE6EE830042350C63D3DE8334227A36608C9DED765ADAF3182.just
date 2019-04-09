bt  = "0"
log = "warn"

check:
	cargo check

test:
	RUST_BACKTRACE={{bt}} cargo test

test-record: build
	RUST_LOG=whim={{log}} ./target/debug/whim record --use-test-feed

record: build
	RUST_LOG=whim={{log}} ./target/debug/whim record

build:
	cargo build

#check:
#	@nix-shell --run "cargo check"
#
#test:
#	@nix-shell --run "RUST_BACKTRACE={{bt}} cargo test"
#
#test-record: build
#	@nix-shell --run "RUST_LOG=whim={{log}} ./target/debug/whim record --use-test-feed"
#
#record: build
#	@nix-shell --run "RUST_LOG=whim={{log}} ./target/debug/whim record"
#
#build:
#	@nix-shell --run "cargo build"
