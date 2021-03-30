# usage
usage:
	@just -l

# prepare
prepare:
	@cargo fmt --help 2>&1 > /dev/null || rustup component add rustfmt
	@cargo clippy --help 2>&1 > /dev/null || rustup component add clippy
	@sccache --help 2>&1 > /dev/null || cargo install sccache
	@cargo audit --help 2>&1 > /dev/null || cargo install cargo-audit

# run
run +OPTION: prepare
	@RUSTC_WRAPPER={{`which sccache`}} cargo run -- {{OPTION}}

# build
build: prepare
	@RUSTC_WRAPPER={{`which sccache`}} cargo build

# fmt
fmt: prepare
	@cargo fmt

# lint
lint: prepare
	@cargo clippy

# audit
audit: lint
	@cargo audit

# test
test: prepare
	@RUSTC_WRAPPER={{`which sccache`}} cargo test

# watch
watch +COMMAND='test': prepare
	@RUSTC_WRAPPER={{`which sccache`}} cargo watch --clear --exec "{{COMMAND}}"

# clean
clean:
	@cargo clean

# vim: set noexpandtab :
