# Checks, documents, and tests everything.
all: check clippy doc test

# Removes compilation artifacts.
clean:
	cargo clean

# Watches the compilation of a target.
watch TARGET="all":
	watchexec -cre rs,toml "just {{TARGET}}"

# Runs various benchmarks.
bench:
	cargo bench --all
# Builds in both debug and release configurations.
build: build-debug build-release
# Builds the project in the debug configuration.
build-debug:
	cargo build
# Builds the project in the release configuration.
build-release:
	cargo build --release
# Checks that the project can compile.
check:
	cargo check --all
# Checks for additional lints.
clippy:
	cargo clippy --all-targets --all-features
# Creates documentation.
doc:
	cargo doc --all
# Fuzzes the parser.
fuzz:
	mkdir -p fuzz/corpus/fuzz_target_1
	cargo +nightly fuzz run fuzz_target_1 fuzz/corpus/fuzz_target_1
# Tests in both debug and release configurations.
test:
	cargo test --all
	cargo test --all --release

# Checks for outdated dependencies.
outdated-deps:
	cargo outdated -R
