all: check build-debug doc test
clean:
	cargo clean
watch TARGET="all":
	watchexec -cre css,html,js,rs,toml "just {{TARGET}}"

build: build-debug build-release
build-debug:
	cargo build --all
build-release:
	cargo build --all --release
check:
	cargo check --all
clippy:
	cargo clippy --all
doc:
	cargo doc --all
test:
	RUST_BACKTRACE=full cargo test --all -- --nocapture
	RUST_BACKTRACE=full cargo test --all --release -- --nocapture

outdated-deps:
	cargo outdated -R
run +ARGS="":
	cargo run -- {{ARGS}}
update-schema:
	diesel print-schema > src/schema.rs
update-schema-destructive: local-nuke-db update-schema

local-nuke-db:
	diesel database reset
local-run-migrations:
	diesel migration run
