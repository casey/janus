################################################################################
#                                   Justfile                                   #
#                                                                              #
# Set of routines to execute for development work. As of 2019-05-01, `just`    #
# does not work on Windows.                                                    #
################################################################################

# Runs the benchmark suite
bench *ARGS:
	cargo +nightly bench {{ARGS}}

# Builds the library.
build:
	cargo build --no-default-features
	cargo build --all-features
	@cargo build --all-features --example sieve
	@cargo build --all-features --example tour

# Checks the library for syntax and HIR errors.
check:
	cargo check --no-default-features
	cargo check --all-features

# Runs all of the recipes necessary for pre-publish.
checkout: format check lint build doc test package

# Continually runs the development routines.
ci:
	just loop dev

# Removes all build artifacts.
clean:
	cargo clean

cross_seq:
	xargs -n1 -I'{}' env ENABLE_CROSS=1 TARGET='{}' ci/script.sh < ci/target_test.txt
	xargs -n1 -I'{}' env ENABLE_CROSS=1 TARGET='{}' DISABLE_TESTS=1 ci/script.sh < ci/target_notest.txt
	xargs -n1 -I'{}' cargo check --no-default-features --target '{}' < ci/target_local.txt

# Runs the development routines.
dev: format lint doc test

# Opens the crate documentation.
# @cargo +nightly doc --all-features {{ARGS}}
doc *ARGS:
	@cargo doc --all-features --no-deps --open {{ARGS}}

# Runs the formatter on all Rust files.
format:
	@cargo +nightly fmt -- --config-path rustfmt.toml

# Runs the linter.
lint: check
	cargo clippy --no-default-features
	cargo clippy --all-features

# Continually runs some recipe from this file.
loop action:
	watchexec -w src -- "just {{action}}"

# Looks for undefined behavior in the (non-doc) test suite.
miri *ARGS:
	cargo +nightly miri test --all-features -q --lib --tests {{ARGS}}

# Packages the crate in preparation for publishing on crates.io
package:
	cargo package --allow-dirty

# Publishes the crate to crates.io
publish: checkout
	cargo publish

# Runs the test suites.
# just miri
test *ARGS: check lint
        cargo test

