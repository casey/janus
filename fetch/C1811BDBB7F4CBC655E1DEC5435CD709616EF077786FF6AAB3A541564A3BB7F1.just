default: test

build:
	cargo build

run:
	cargo run -- github-ssh casey remote

test:
	cargo test

readme:
	echo '```' > README.md
	cargo run -- --help >> README.md
	echo '```' >> README.md
