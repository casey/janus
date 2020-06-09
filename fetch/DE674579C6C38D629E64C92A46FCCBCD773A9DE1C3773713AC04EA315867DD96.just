build:
	cargo fmt
	cargo build

run +ARGS="":
	cargo fmt
	cargo run {{ARGS}}

clean:
	cargo clean
	rm -rf web/build

test:
	cargo test --features build-outcomes
