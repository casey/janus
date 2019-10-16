# Checks, builds, documents, and tests everything.
all: check clippy build-debug doc test build-dist

# Watches the compilation of a target.
watch TARGET="all":
	watchexec -cre lalrpop,rs,toml "just {{TARGET}}"

################################################################################
################################# PROJECT-WIDE #################################
################################################################################

# Builds a distributable tarball as flubber.tgz.
build-dist: build-release build-bridges
	#!/bin/bash
	if [[ -d tmp ]]; then rm -r tmp; fi
	install -d tmp/flubber/bin tmp/flubber/lib/flubber/bridges
	install -t tmp/flubber/bin target/release/flubber
	install -t tmp/flubber/lib/flubber/bridges bridges/signal/build/libs/flubber-bridge-signal.jar
	mkdir -p dist
	tar czfC dist/flubber.tgz tmp flubber

# Removes compilation artifacts.
clean:
	cargo clean
	rm -rf dist tmp

# Creates documentation.
doc:
	cargo doc --all
	mkdir -p dist/docs/book
	mdbook build book -d ../dist/docs

################################################################################
#################################### DAEMON ####################################
################################################################################

# Builds the Flubber daemon in the debug configuration.
build-debug:
	cargo build
# Builds the Flubber daemon in the release configuration.
build-release:
	cargo build --release
# Checks that the Flubber daemon can compile.
check:
	cargo check --all
# Checks for additional lints.
clippy:
	cargo clippy --all
# Tests the Flubber daemon in both debug and release configurations.
test:
	cargo test --all
	cargo test --all --release

# Checks for outdated dependencies.
outdated-deps:
	cargo outdated -R

# Runs the Flubber daemon.
run +ARGS="":
	cargo run --bin flubber -- {{ARGS}}

################################################################################
################################### BRIDGES ####################################
################################################################################

# Builds all the bridges.
build-bridges: build-bridge-signal

# Builds the Signal bridge.
build-bridge-signal:
	cd bridges/signal && ./gradlew build jar

################################################################################
##################################### MISC #####################################
################################################################################

# Runs the CI script.
ci: build-dist doc
	rsync -a target/doc/ dist/docs/
	rsync -a target/x86_64-unknown-linux-musl/doc/ dist/docs/
	chown $(stat -c "%u:%g" Justfile) -R .
