watch +args='test':
	cargo watch --ignore fetch --ignore link --ignore search --clear --exec '{{ args }}'

run: (search ) fetch analyze

set dotenv-load

search:
	cargo run --release search

fetch:
	cargo run --release fetch

analyze:
	cargo run --release analyze
