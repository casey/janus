# wengwengweng

name := "packapp"

run +args="":
	cargo run -- {{args}}

install:
	cargo install --force --path .

pack:
	rm -rf pkg
	mkdir -p pkg
	cp target/release/{{name}} pkg/{{name}}
	upx pkg/{{name}}
	zip pkg/{{name}}-x86_64-apple-darwin.zip pkg/{{name}}
	rm pkg/{{name}}

doc crate="packapp":
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

