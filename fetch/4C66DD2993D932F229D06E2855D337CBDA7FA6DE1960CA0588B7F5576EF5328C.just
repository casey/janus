default: codegen

run:
	cargo run

check:
	cargo check

get:
	curl https://www.unicode.org/Public/UCD/latest/ucd/Blocks.txt > codegen/blocks.txt

codegen:
	(cd codegen && cargo run) | rustfmt > src/block.rs

build:
	cargo build

readme: build
	echo '# uniblocks' 			 >  README.md
	echo 										 >> README.md
	echo '```' 				       >> README.md
	./target/debug/uniblocks >> README.md
	echo '```'						   >> README.md
