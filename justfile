watch +args='test':
	cargo watch --ignore fetch --ignore link --ignore search --clear --exec '{{ args }}'

run USER-SESSION: (search USER-SESSION) fetch analyze

search USER-SESSION:
	cargo run --release -- search --user-session {{USER-SESSION}}

fetch:
	cargo run --release -- fetch

analyze:
	cargo run --release -- analyze
