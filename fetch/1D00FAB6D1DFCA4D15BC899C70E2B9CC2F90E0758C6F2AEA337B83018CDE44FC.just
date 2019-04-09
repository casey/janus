# wengwengweng

run example="yo":
	cargo run --example basic

doc:
	cargo doc --no-deps --open

loc:
	tokei

checkdep:
	cargo outdated --depth 1

