check: 
    cargo watch --clear --exec check

test: 
    cargo watch --clear --exec test

test-print:
    cargo test -- --nocapture

build: 
	cargo build --release

run: 
	cargo build --release
	./target/release/qcal format 0xDEADBEEF 3 o24 b1101101 
	./target/release/qcal endian 55bd840a78798ad0da853f68974f3d183e2bd1db6a842c1feecf222a00000000
	./target/release/qcal endian 29263ed541e0072216baa08ead2d787754cb882f573543a10000486e00000000
	./target/release/qcal endian abcdef
	./target/release/qcal add 0xFF 30 o24 b111 
	./target/release/qcal sub 0xFF 30 o24 b111 
	./target/release/qcal mul 0xFF 30 o24 b111 
	./target/release/qcal div 0xFF 30 o24 b111 
	./target/release/qcal bytelen 0xFF 0xDEADBEEF
	./target/release/qcal charlen 0xFF 0xDEADBEEF

publish:
	cargo build
	cargo publish
