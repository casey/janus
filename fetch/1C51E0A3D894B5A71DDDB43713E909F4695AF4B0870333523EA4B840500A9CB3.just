#!/usr/bin/env just --justfile

DEFAULT_TARGETS := '
	arm-unknown-linux-musleabi
	arm-unknown-linux-musleabihf
	armv7-unknown-linux-musleabihf
	i686-unknown-linux-musl
	x86_64-unknown-linux-musl
	x86_64-unknown-netbsd
	x86_64-apple-darwin
'

BINARY_NAME := 'superkeyloader'

ARTIFACTS_DIRECTORY := `pwd` + '/raaaandomstuff-artifacts'
SOURCE_DIRECTORY := `pwd`

CARGO_TOKEN := "test"


###########################
# Development Environment #
###########################

install-dev-deps:
	@echo '> Will install `convco`, `grcov`, and `rusty-hook` globally'
	cargo install convco grcov rusty-hook
	@echo '> Development dependencies installed'
	#
	@echo '> Will install rust nightly toolchain (required by `grcov`)'
	rustup toolchain install nightly
	@echo '> Nightly toolchain installed'
	#
	@echo '> Installing clippy and rustfmt'
	rustup component add clippy
	rustup component add rustfmt
	@echo '> Clippy and rustfmt tinstalled'

install-hooks:
	@echo '> Installing git hooks'
	rusty-hook init
	@echo '> Git hooks installed'

setup-dev-env:
	just install-dev-deps
	just install-hooks


#####################
# Development Tools #
#####################

check:
	@echo '> Check code formatting and linting'
	cargo fmt -- --check
	cargo clippy --all-targets --all-features -- -D warnings
	@echo '> Wow! Everything is correctly formated and lint'

test:
	@echo '> Test everything!'
	cargo test

build:
	@echo '> Build on default target'
	cargo build

coverage TYPE='html' OUTPUT='./target/debug/coverage/':
	# This will also build and test on nightly
	@echo '> Setting up Rust environment variables for `grcov`'
	export CARGO_INCREMENTAL=0
	export RUSTFLAGS="-Zprofile -Ccodegen-units=1 -Cinline-threshold=0 \
		-Clink-dead-code -Coverflow-checks=off -Zno-landing-pads"
	@echo '> Building and testing with nightly'
	# rustup run nightly cargo build
	rustup run nightly cargo test
	@echo '> Generating HTML code coverage report'
	grcov ./target/debug/ -s . -t {{TYPE}} --llvm --branch --ignore-not-existing -o {{OUTPUT}} --ignore "/*" --ignore "../*"
	@echo '> View report at `./target/debug/coverage/index.html`'


#############
# Git Hooks #
#############

pre-commit:
	@echo '> Check formatting, lint code'
	# Check code for correct formatting (doesn't autoformat)
	#  and lint code in the most pedantic way
	just check

commit-msg:
	# TODO: After solving non-rust dependencies problem with `commitlint`

pre-push:
	@echo '> Test code and verify commit messages'
	# Checks if your commit messages meet the conventional commit format (see https://www.conventionalcommits.org/en/v1.0.0/)
	# Keep the remote repo clean
	# TODO: Move to `commit-msg` after finding a good solution
	convco check
	# Code on remote repo must work, so let's test it before pushing it
	just test


# vim: set ft=make :

