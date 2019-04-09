clean:
	cargo clean

checkout:
	cargo check
	cargo doc --features testing --document-private-items
	cargo build
	cargo build --example sieve
	cargo build --example tour
	cargo test --features testing
	cargo package --allow-dirty

dev:
	cargo check --features ffi
	cargo test --features testing,ffi
	cargo doc --features testing,ffi --document-private-items

doc:
	cargo doc --features testing,ffi --document-private-items
	mkdir -p target/ffi/docs
	doxygen ffi/Doxyfile
ci:
	cargo watch -s "just dev"

foreign:
	cargo build --features ffi
	clang++ -std=c++11 -Iffi -Ltarget/debug examples/foreign.cpp -lbitvec -o target/foreigner
	target/foreigner
