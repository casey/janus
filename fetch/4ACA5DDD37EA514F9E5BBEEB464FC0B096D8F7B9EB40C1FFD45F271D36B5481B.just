# wengwengweng

run example="yo":
	cargo run --release --example {{example}}

doc:
	cargo doc --no-deps --open

loc:
	loc

checkdep:
	cargo outdated --root-deps-only

test-windows example="yo":
	cargo build --release --target x86_64-pc-windows-gnu --example {{example}}

