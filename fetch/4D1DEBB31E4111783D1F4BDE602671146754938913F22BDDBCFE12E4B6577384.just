all: check build-debug doc test
clean:
	cargo clean
watch TARGET="all":
	watchexec -cre rs,toml "just {{TARGET}}"

build: build-debug build-release
build-debug:
	cargo build
build-release:
	cargo build --release
check:
	cargo check --all
clippy:
	cargo clippy --all
doc:
	cargo doc --all
test:
	RUST_BACKTRACE=full cargo test --all -- --nocapture
	RUST_BACKTRACE=full cargo test --all --release -- --nocapture
	mdbook test docs

outdated-deps:
	cargo outdated -R
run +ARGS="":
	cargo run -- {{ARGS}}
run-example +ARGS="":
	just run -c flubber.example.toml {{ARGS}}
