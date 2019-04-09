all: check doc build test
build: build-debug build-release
build-debug:
	cargo build --all
build-release:
	cargo build --all --release
check:
	cargo check --all
clean:
	cargo clean
doc:
	cargo doc --all
test: test-debug test-release
test-debug:
	cargo test --all
test-release:
	cargo test --all --release
watch TARGET="all":
	watchexec -cre pest,rs,toml "just {{TARGET}}"

travis-ci: doc build test
