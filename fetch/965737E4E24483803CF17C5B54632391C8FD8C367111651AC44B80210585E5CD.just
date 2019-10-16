# wengwengweng

run example="sprite":
	cargo run --example {{example}} --release

run-lua example="app":
	./bin/dirty examples/{{example}}.lua

install:
	cargo install --force --path .

build:
	cargo build --release

build-web:
	cargo build --target wasm32-unknown-unknown

build-ios:
	cargo build --target x86_64-apple-ios

build-windows:
	cargo build --release --target x86_64-pc-windows-gnu

build-linux:
	cargo build --release --target x86_64-unknown-linux-gnu

doc crate="dirty":
	cargo doc --no-deps --open -p {{crate}}

update:
	cargo update

bloat:
	cargo bloat --release --crates

loc:
	loc

checkdep:
	cargo outdated --root-deps-only

depgraph:
	cargo deps --all-deps | dot -Tpng > $TMPDIR/graph.png; \
		open $TMPDIR/graph.png

