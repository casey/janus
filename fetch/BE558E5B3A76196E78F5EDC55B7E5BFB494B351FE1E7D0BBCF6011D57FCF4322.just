all: check doc build-debug test
clean:
	cargo clean
watch TARGET="all":
	watchexec -cre css,html,rs,toml "just {{TARGET}}"

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
	cargo test --all

build-docker:
	docker build -t acmumn/mailer .
outdated-deps:
	cargo outdated -R

run +ARGS="":
	cargo run -- {{ARGS}}

update-schema:
	diesel print-schema > src/db/schema.rs
