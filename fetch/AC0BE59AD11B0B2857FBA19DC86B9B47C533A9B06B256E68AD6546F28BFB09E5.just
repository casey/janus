d: 
	cargo build 
	cargo run target/debug/strs -o d

d-o: 
	cargo build 
	cargo run target/debug/strs -o o

d-x: 
	cargo build 
	cargo run target/debug/strs -o x

r: 
	cargo build --release
	cargo run --release target/release/strs ./target/release/strs

publish: update-readme
	cargo build
	cargo publish

update-readme:
	echo '# strs' > README.md
	echo '*strs* is a modern alternative to [*strings*](https://linux.die.net/man/1/strings).' >> README.md
	echo '' >> README.md
	echo '```' >> README.md
	cargo run -- --help >> README.md
	echo '```' >> README.md

