all: check build doc test

build:
	cargo build --all
build-release:
	cargo build --all --release
check:
	cargo check --all
clippy:
	cargo clippy --all
doc:
	mdbook build docs
	cargo doc --all
	rsync -a target/doc/ docs/book/api/
run +ARGS="":
	cargo run -- -I . -I examples {{ARGS}}
test:
	cargo test --all -- --nocapture
watch +TARGETS="all":
	watchexec -cre lalrpop,rs,stahl,stahld -- just {{TARGETS}}

open-docs: doc
	cargo doc --open --package stahl
twelf-repl NAME:
	cd metatheory/{{NAME}} && rlwrap -P make twelf-server
twelf-watch NAME:
	cd metatheory/{{NAME}} && watchexec -cre elf "echo make | twelf-server"
