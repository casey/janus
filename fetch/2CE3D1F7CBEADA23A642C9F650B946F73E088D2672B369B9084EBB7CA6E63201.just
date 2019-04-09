watch:
	cargo watch --clear --shell 'just test'

test:
	cargo test
	cargo test --features location

doc:
	cargo doc --open

readme:
	#!/usr/bin/env bash
	(
		echo '# position'
		echo
		echo -n '[![crates.io](https://img.shields.io/crates/v/position.svg)](https://crates.io/crates/position)'
		echo ' [![docs](https://docs.rs/position/badge.svg)](http://docs.rs/position)'
		echo
		grep '^//!' src/lib.rs | sed -E 's/^...[ ]?//'
	) > README.md
