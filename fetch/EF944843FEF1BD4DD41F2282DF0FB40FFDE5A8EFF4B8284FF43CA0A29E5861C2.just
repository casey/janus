all: check doc test build-release
clean:
	cargo clean
watch TARGET="all":
	watchexec -re rs,toml "just {{TARGET}}"

bench:
	cargo +nightly bench --all
build: build-debug build-release
build-debug:
	cargo build --all
build-release:
	cargo build --all --release
check:
	cargo check --all
clippy:
	cargo +nightly clippy --all
doc:
	cargo doc --all
run +ARGS="":
	cargo run --bin game -- {{ARGS}}
run-release +ARGS="":
	cargo run --bin game --release -- {{ARGS}}
run-maptool +ARGS="":
	cargo run --bin maptool -- {{ARGS}}
run-rendertest +ARGS="":
	cargo run --bin rendertest -- {{ARGS}}
test:
	cargo test --all

open-docs:
	cargo doc --open
outdated-deps:
	cargo outdated -R
