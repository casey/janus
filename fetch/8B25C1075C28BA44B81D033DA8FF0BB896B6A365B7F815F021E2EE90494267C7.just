set shell := [ "bash", "-eu", "-o", "pipefail", "-c" ]

DEFAULT: build

build option='':
	@ cargo build {{option}}

run: (build '')
	@ sudo ./target/debug/rather

test:
	cargo clippy --all-targets --all-features -- -D warnings
	cargo test

fmt:
	@ cargo fmt


doc open='':
	cargo doc {{open}}
