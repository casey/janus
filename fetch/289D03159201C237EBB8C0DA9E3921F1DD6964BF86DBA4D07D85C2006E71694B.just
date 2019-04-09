default:
	rm -rf tmp
	mkdir tmp
	cat src/main.rs | cargo run > tmp/braille.txt
	cat tmp/braille.txt | cargo run -- --bytes > tmp/bytes.txt
	diff tmp/bytes.txt src/main.rs
