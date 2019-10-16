# wengwengweng

run +args="":
	cargo run -- {{args}}

install:
	cargo install --force --path .

doc crate="cargo-app":
	cargo doc --no-deps --open -p {{crate}}

update:
	cargo update

bloat:
	cargo bloat --release --crates

loc:
	loc

checkdep:
	cargo outdated --root-deps-only

