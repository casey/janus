# default to `watch`
default: watch

bt="0"

export RUST_BACKTRACE = bt

# submit a pull request
pr: fmt clippy test
	@echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/*.rs
	@echo Checking for long lines...
	! grep --color -En '.{101}' src/*.rs
	git branch | grep '^ *master'
	git diff --exit-code
	git diff --cached --exit-code
	git push github

# run all tests
test:
	cargo test

# format rust sourcecode with rustfmt
fmt:
	cargo fmt --all

# watch for changes and run `cargo fmt` and `cargo check`
watch:
	cargo watch --clear --exec fmt --exec 'check --all-targets'

# check all targets
check:
	cargo check --all-targets

# check for out-of-date dependencies
outdated:
	cargo outdated

# build and open docs
doc:
	cargo doc --open -p pxl

# everyone's favorite animate paper clip
clippy:
	cargo +nightly clippy

# run the conway's game of life example
life:
	cargo run --package pxl --release --example life

# run the custom shader example
shaders:
	cargo run --package pxl --release --example shaders

# run pxl-mono
mono:
	cargo run --package pxl-mono --release

# run all examples in sequence, useful for testing
examples: life mono shaders

# clean up the feature branch named BRANCH
done BRANCH:
	git checkout master
	git pull --rebase github master
	git diff --no-ext-diff --quiet --exit-code {{BRANCH}} --
	git branch -D {{BRANCH}}
