watch:
	cargo watch --ignore fetch --ignore link --ignore search --clear --exec check

search user-session:
	cargo run --release -- search --user-session {{user-session}}

fetch:
	cargo run --release -- fetch

analyze:
	cargo run --release -- analyze
