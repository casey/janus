all: check doc build test build-release
build:
	cargo build --all
build-release:
	cargo build --all --release
check:
	cargo check --all
clean:
	cargo clean
doc:
	cargo doc --all
test:
	cargo test --all
watch TARGET="all":
	watchexec -cr "just {{TARGET}}"
