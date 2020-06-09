# wengwengweng

name := "packapp"

run +args="":
	cargo run -- {{args}}

build:
	cargo build --release

install:
	cargo install \
		--force \
		--path .

pack:
	rm -rf pkg
	mkdir -p pkg
	cp target/release/{{name}} pkg/{{name}}
	upx pkg/{{name}}
	zip pkg/{{name}}-x86_64-apple-darwin.zip pkg/{{name}}
	rm pkg/{{name}}
	sha256sum pkg/{{name}}-x86_64-apple-darwin.zip

doc crate="packapp":
	cargo doc \
		--no-deps \
		--open \
		--all-features \
		-p {{crate}}

update:
	cargo update
	cargo outdated --root-deps-only

bloat:
	cargo bloat --release --crates

loc:
	loc

