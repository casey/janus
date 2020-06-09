default: watch

watch:
	cargo watch --clear --exec 'test --all'

test:
	cargo test --all

fmt:
	cargo +nightly fmt --all

clippy:
	cargo clippy --all

publish: test clippy
	cargo publish
	git push github
