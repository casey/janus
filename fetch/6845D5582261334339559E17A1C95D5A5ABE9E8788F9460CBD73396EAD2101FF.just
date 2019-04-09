# Copyright 2017 Aldrin J D'Souza.
# Licensed under the MIT License <https://opensource.org/licenses/MIT>

# kcov runtime arguments
kcov-cmd="kcov --exclude-pattern=/usr/local/cargo,/usr/lib,/src/tests --verify" 

# cargo test files are randomly named, this jq pipeline can identify them
get-test-files="jq -r 'select(.profile.test == true) | .filenames[]'"

# CI default target
check: show clean cover

# Show installed toolset
show:
	@rustup show
	@cargo --version
	@rustc --version
	@just --version

# Clean the workspace
clean:
	cargo clean

# Run tests and measure code coverage
cover:
	cargo test --target=x86_64-unknown-linux-gnu --no-run --message-format=json | {{ get-test-files }} | xargs -n 1 {{ kcov-cmd }} target/kcov

# Run sanitizers
sanitize SAN:
	RUSTFLAGS="-Z sanitizer={{ SAN }}" rustup run nightly cargo test --target x86_64-unknown-linux-gnu

# Local Variables:
# mode: makefile
# End:
