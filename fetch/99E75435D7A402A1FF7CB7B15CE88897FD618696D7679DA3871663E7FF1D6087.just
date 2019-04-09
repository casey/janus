default: test-spec

test:
	cargo test --release

test-spec:
	cargo test --release spec -- --nocapture

test-backtrace:
	RUST_BACKTRACE=1 cargo test

# only run tests matching PATTERN
filter PATTERN:
	cargo test {{PATTERN}}

check:
	cargo check

build:
	cargo build

watch-test:
	cargo watch clear test

watch COMMAND='test':
	cargo watch {{COMMAND}}

fmt: no-changes
	rustfmt --overwrite

fmt-backup:
	rustfmt

delete-fmt-backups:
	find . -name '*.rs.bk' -delete

clippy:
	rustup run nightly cargo clippy -- -D clippy

version = `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml`

publish: no-changes lint clippy
	git branch | grep '* master'
	git co -b {{version}}
	git push upstream
	git tag -a {{version}} -m {{version}}
	git push upstream --tags
	cargo publish
	@echo 'Remember to merge the {{version}} branch on GitHub!'

# this is so you open a PR from a single commit without having to create a local branch
# push master to upstream remote as a branch named GITHUB-BRANCH
push GITHUB-BRANCH:
	git branch | grep '* master'
	git diff --no-ext-diff --quiet --exit-code
	git push upstream master:refs/heads/{{GITHUB-BRANCH}}

sloc:
	@cat src/*.rs | sed '/^\s*$/d' | wc -l

# will fail if there are outstanding changes in the repo
no-changes:
	git diff --no-ext-diff --quiet --exit-code

@lint:
	echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/*.rs examples/*.rs
	echo Checking for long lines...
	! grep --color -En '.{100}' src/*.rs examples/*.rs

install-rust:
	curl https://sh.rustup.rs -sSf | sh

install-dev-dependencies:
	rustup install stable
	rustup install nightly
	cargo install rustfmt
	cargo install cargo-check
	cargo install cargo-watch
	rustup run nightly install clippy

update-dev-dependencies:
	rustup update stable
	rustup update nightly
	cargo install -f just
	cargo install -f rustfmt
	cargo install -f cargo-check
	cargo install -f cargo-watch
	rustup run nightly install -f clippy

run-examples:
	#!/usr/bin/env bash
	set -eu
	for path in examples/*; do
		filename=`basename $path`
		cargo run --example ${filename%.*}
	done

# clean up feature branch named BRANCH
done BRANCH:
	git checkout {{BRANCH}}
	git pull --rebase upstream master
	git checkout master
	git pull --rebase upstream master
	git branch -d {{BRANCH}}

update-boilerplate:
	git pull --rebase=false boilerplate master

update-spec:
	curl 'https://raw.githubusercontent.com/keybase/warpwallet/master/test/spec.json' > spec.json
