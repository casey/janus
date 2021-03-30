# path to dirs
gateway := "gateway"
leveling := "leveling"
slash_cmds := "slash_cmds"

release_dir := env_var_or_default("RELEASE_DIR", "release")

@build:
	just build-gateway
	just build-leveling
	just build-cmds

build-gateway:
	cargo build --package {{gateway}}

build-leveling:
	cargo build --package {{leveling}}

build-cmds:
	yarn --silent install --frozen-lockfile
	yarn --silent run compile

build-release:
	cargo build --release --quiet
	just build-cmds

release:
	#!/usr/bin/env bash
	just build-release
	yarn --silent run release:slash_cmds 1>/dev/null
	#
	CARGO_OUT="{{justfile_directory()}}/target/release"
	TSC_OUT="{{justfile_directory()}}/build"
	#
	files=(
		"${CARGO_OUT}/{{gateway}}"
		"${CARGO_OUT}/{{leveling}}"
	)
	#
	cp "${files[@]}" {{release_dir}}

clean:
	cargo clean
	yarn --silent run clean
	rm -rf {{justfile_directory()}}/node_modules
	rm -rf {{justfile_directory()}}/{{release_dir}}

test:
	cargo test
	yarn --silent run test

default:
	just build

# vim: ft=make
