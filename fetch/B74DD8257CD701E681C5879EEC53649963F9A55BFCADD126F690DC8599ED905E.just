# Checks, builds, documents, and tests everything.
all: check clippy build-debug doc build-release test

# Removes compilation artifacts.
clean:
	cargo clean
	[[ -d dist ]]; rm -r dist

# Watches the compilation of a target.
watch TARGET="all":
	watchexec -cre frag,lalrpop,md,rs,toml,vert -i docs/book.toml -i 'docs/book/**' "just {{TARGET}}"

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
	mdbook build docs
# Tests in both debug and release configurations.
test:
	cargo test --all
	cargo test --all --release
# Runs tests of all crates that use unsafe under miri.
test-miri:
	#!/bin/bash
	for dir in {bins,libs}/*; do
		if grep -R unsafe $dir/src >/dev/null; then
			just test-miri-one $dir
		fi
	done
# Runs tests of a single crate under miri.
test-miri-one DIR:
	cd {{DIR}}; cargo +nightly miri test -- -Zmiri-seed=12345678 -- -Zunstable-options --exclude-should-panic

# Checks for outdated dependencies.
outdated-deps:
	cargo outdated -R

# Runs the asset tool.
asset-tool +ARGS="":
	cargo run --bin ia-asset-tool -- {{ARGS}}
# Runs the debug tool.
debug-tool +ARGS="":
	cargo run --bin ia-internal-debug-tool -- {{ARGS}}
# Runs the model viewer.
model-viewer +ARGS="":
	cargo run --bin ia-model-viewer -- {{ARGS}}
# Runs the game itself.
run +ARGS="":
	cargo run --bin ia -- {{ARGS}}

# Fuzzes the IQM parser.
fuzz-iqm:
	mkdir -p libs/iqm/fuzz/corpus/fuzz_target_1
	cd libs/iqm; cargo +nightly fuzz run fuzz_target_1 fuzz/corpus/fuzz_target_1 \
		$(find ../.. -type f -name '*.iqm' | sed -r 's#/[^/]+$##' | sort | uniq)

# Runs the equivalent of the CI system.
ci:
	docker pull rust:latest
	docker build -t remexre/ia-builder .travis
	docker run -v "$(pwd):/code" --rm remexre/ia-builder just ci-tests
	docker run -v "$(pwd):/code" --rm remexre/ia-builder just ci-dist
	docker run -v "$(pwd):/code" --rm remexre/ia-builder just ci-fix-privileges

# Builds distributable artifacts to dist.
ci-dist: doc
	cd bins/ia && cargo build --features bundle_assets --release
	[ -d dist ] && rm -r dist || true
	mkdir -p dist/docs/api
	rsync -a docs/book/ dist/docs/
	rsync -a target/doc/ dist/docs/api/

# Sets privileges for all files to those of this Justfile.
ci-fix-privileges:
	chown -R $(stat -c "%u:%g" Justfile) .

# Runs tests on every commit.
ci-tests: test test-miri
