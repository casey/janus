test:
	cargo watch --clear --exec test

run:
	cargo watch --clear --exec run

check:
	cargo watch --clear --exec test

diff:
	#!/usr/bin/env bash

	cargo build
	colordiff \
		<(cat ./target/debug/strs | strings) \
		<(cat ./target/debug/strs | ./target/debug/strs)
	colordiff \
		<(cat ./target/debug/strs | strings) \
		<(cat ./target/debug/strs | ./target/debug/strs) \
		| wc -l
