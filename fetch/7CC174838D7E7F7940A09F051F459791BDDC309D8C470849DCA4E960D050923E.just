# wengwengweng

run example="basic":
	cargo run --release --example {{example}}

doc:
	cargo doc --no-deps --open

loc:
	tokei

checkdep:
	cargo outdated --depth 1

