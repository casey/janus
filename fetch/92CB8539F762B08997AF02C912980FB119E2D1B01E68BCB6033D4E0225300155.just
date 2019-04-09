# wengwengweng

run:
	cargo run --release

loc:
	tokei

checkdep:
	cargo outdated --root-deps-only

doc:
	cargo doc --no-deps --open

test-windows :
	cargo build --release --target x86_64-pc-windows-gnu

