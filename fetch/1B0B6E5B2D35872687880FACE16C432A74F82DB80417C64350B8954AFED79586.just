all: check build test
build: build-debug build-release
build-debug: migrations
	cargo build
build-release: migrations
	cargo build --release
check:
	cargo check
migrations:
	diesel migration run
run: build-release
	target/release/tri
run-forever: build-release
	until target/release/tri |& tee -a tri.log; do true; done
test: test-debug test-release
test-debug: migrations
	cargo test
test-release: migrations
	cargo test --release
watch:
	cargo watch -s "just migrations" -x check -x doc -x test -x run

travis-ci: migrations build test
