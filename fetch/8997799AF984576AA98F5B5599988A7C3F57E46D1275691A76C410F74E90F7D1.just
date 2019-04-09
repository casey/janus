test:
	cargo test

version = `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml`

# publish to crates.io
publish: lint test readme # clippy
	git branch | grep '* master'
	git diff --no-ext-diff --quiet --exit-code
	cargo publish
	git tag -a {{version}} -m 'Release {{version}}'
	git push github {{version}}

# everyone's favorite animate paper clip
clippy:
	cargo +nightly clippy

@lint:
	echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/*.rs
	echo Checking for long lines...
	! grep --color -En '.{101}' src/*.rs

readme:
	echo '# imglife' 		>  README.md
	echo 							  >> README.md
	echo '```' 					>> README.md
	cargo run -- --help >> README.md
	echo '```' 					>> README.md

step-blinkers:
	cargo run -- --alive '#00D1FB' --dead black blinkers.png output.png
	open output.png

step-104p177:
	cargo build --release
	rm -rf output
	mkdir output
	cp 104P177.png output/output0.png
	for i in `seq 0 177`; do ./target/release/imglife --alive '#00D1FB' --dead black output/output$i.png output/output$((i + 1)).png; done
	open output0.png
