export RUST_BACKTRACE = "1"

watch:
	cargo watch --clear --exec test

doc:
	cargo doc --open

readme:
	#!/usr/bin/env bash
	(
		echo '# oi'
		echo
		echo -n '[![crates.io](https://img.shields.io/crates/v/oi.svg)](https://crates.io/crates/oi)'
		echo ' [![docs](https://docs.rs/oi/badge.svg)](http://docs.rs/oi)'
		echo
		grep '^//!' src/lib.rs | sed -E 's/^...[ ]?//'
	) > README.md
