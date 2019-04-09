all: check
	cargo doc --all
	cargo build --all
	cargo test --all

check:
	cargo check --all

distbuild:
	cargo build --release --features=play,simulate,train

make-and-train:
	mkdir -p test-data/results
	cargo run --release new test-data/test.gen -p 1
	cargo run --release train --results test-data/results test-data/test.gen

play:
	cargo run --release play

test-with-features FEATURES:
	cargo build --no-default-features --features={{FEATURES}}
	cargo test --no-default-features --features={{FEATURES}}

travis-ci:
	just test-with-features play
	just test-with-features simulate
	just test-with-features train
	just test-with-features play,simulate
	just test-with-features play,train
	just test-with-features simulate,train
	just test-with-features play,simulate,train
	just distbuild

watch TARGET="all":
	watchexec -cre frag,rs,toml,vert "just {{TARGET}}"
