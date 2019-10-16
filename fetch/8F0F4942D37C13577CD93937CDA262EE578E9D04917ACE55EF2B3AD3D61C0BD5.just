bt := '0'

export RUST_BACKTRACE := bt

watch:
	cargo watch --exec test

readme:
	#!/usr/bin/env awk -f

	BEGIN {
		ARGV[1] = "src/lib.rs"
		ARGC = 2
	
		readme = "README.md"

		print "# bak" > readme
		print "" >> readme
		print "[![crates.io](https://img.shields.io/crates/v/bak.svg)](https://crates.io/crates/bak) [![docs](https://docs.rs/bak/badge.svg)](http://docs.rs/bak)" >> readme
		print "" >> readme
	}

	/\/\/!/ {
		sub(/^\/\/!( )?/, "")
		print $0 >> readme
	}
