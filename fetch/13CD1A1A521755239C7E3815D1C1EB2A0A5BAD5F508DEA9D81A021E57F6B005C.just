# wengwengweng

run:
	cargo run

loc:
	loc

update:
	cargo update

checkdep:
	cargo outdated --root-deps-only

doc crate="ttx":
	cargo doc --no-deps --open -p {{crate}}

