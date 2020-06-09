# wengwengweng

set shell := ["fish", "-c"]
name := "space55"
version := "0.0.0"

@run +args="":
	cargo run --release -- {{args}}

@macos:
	icns icon.png icon.icns
	rm -rf dist/{{name}}.app
	rm -rf dist/{{name}}_v{{version}}_mac.tar.gz
	upx target/release/{{name}} -o {{name}}
	packapp {{name}} --name {{name}} --icon icon.icns -o dist/{{name}}.app
	cd dist; \
		zip -r -9 {{name}}_v{{version}}_mac.zip {{name}}.app
	rm {{name}}
	rm icon.icns

@doc crate:
	cargo doc --no-deps --open -p {{crate}}

@update:
	cargo update

@bloat:
	cargo bloat --release --crates

@loc:
	loc

@checkdep:
	cargo outdated --root-deps-only

@depgraph:
	cargo deps --all-deps | dot -Tpng > $TMPDIR/graph.png; \
		open $TMPDIR/graph.png

