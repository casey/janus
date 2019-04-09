all: check doc build-debug test
clean:
	cargo clean
watch TARGET="all":
	watchexec -cre css,html,lalrpop,rs,toml "just {{TARGET}}"

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
test:
	RUST_BACKTRACE=full cargo test --all -- --nocapture

build-docker:
	docker build -t acmumn/thetis .
open-docs PKG="thetis": doc
	cargo doc --open -p {{PKG}}
outdated-deps:
	cargo outdated -R
run +ARGS="":
	cd server && cargo run -- {{ARGS}}
update-schema:
	diesel print-schema > server/src/db/schema.rs
