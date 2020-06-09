default: watch

# watch filesystem for changes and rerun tests
watch +ARGS='':
	cargo watch --clear --exec 'test {{ARGS}}'

test:
	cargo test --all

clippy:
	cargo clippy --all

fmt:
	cargo +nightly fmt --all

run:
    cargo run

done: 
    just clippy && \
    just test && \
    just fmt