# use `just` to run the commands in this file: github.com/casey/just

run:
	cargo run

watch:
	cafgo watch --clear --exec run
