# default to watch
default: watch

log='warn'

bt='0'

version = `head -3 Cargo.toml | sed -En 's/^version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p'`

export RUST_BACKTRACE = bt

# run tests
test:
	cargo test

# format source with rustfmt
fmt:
	cargo fmt

# run linter
@lint:
	echo Checking for TODO/FIX/XXX...
	! grep --color -Ern 'TODO|FIX|XXX' src
	echo Checking for lines over 100 columns...
	! grep --color -Ern '.{101}' src
	echo Invoking clippy...
	cargo +nightly clippy -- \
		-D clippy \
		-D clippy_style \
		-D clippy_complexity \
		-D clippy_correctness \
		-D clippy-perf

# build and open docs
doc:
	cargo rustdoc --open -- --document-private-items

# run a command whenever changes are detected
watch:
	cargo watch --clear --exec test

# build
build:
	cargo build

# check
check:
	cargo check

run:
	cargo run

# count non-empty lines of code
sloc:
	@cat src/*.rs | sed '/^\s*$/d' | wc -l

# assert that the repo has no staged or unstaged changes
assert-clean:
	git diff --no-ext-diff --quiet --exit-code
