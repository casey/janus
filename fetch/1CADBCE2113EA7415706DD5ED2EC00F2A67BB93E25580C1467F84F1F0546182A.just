# wengwengweng

check:
	cargo c \
		--all-features

check-web:
	cargo c \
		--all-features \
		--target wasm32-unknown-unknown

run example args="":
	cargo run \
		--example {{example}} \
		--all-features \
		-- \
		{{args}}

build-web example:
	cargo build \
		--example {{example}} \
		--release \
		--all-features \
		--target wasm32-unknown-unknown
	wasm-bindgen target/wasm32-unknown-unknown/release/examples/{{example}}.wasm \
		--out-dir site/examples \
		--target web \
		--no-typescript

build-web-all:
	rm -rf site/examples/*
	for e in tri sprite shader model 3d canvas input displace mask spline ui audio data; do \
		just build-web $e; \
		done

run-site:
	cd site; \
		vc dev

deploy-site:
	cd site; \
		vc --prod

test:
	cargo test \
		--all-features
	cargo test \
		--all-features \
		--target wasm32-unknown-unknown

build:
	cargo build

doc crate="dirty":
	cargo doc \
		--no-deps \
		--open \
		--all-features \
		-p {{crate}}

build-doc:
	rm -rf target/doc
	cargo rustdoc \
		--release \
		--all-features \
		-- \
		--extend-css misc/doc.css
	rm -rf site/doc
	cp -r target/doc site/
	cp site/doc/light.css site/doc/dark.css
	cp logo.png site/doc/rust-logo.png
	convert logo.png -resize 128x128 -filter point site/doc/favicon.ico

update:
	cargo update
	cargo outdated --root-deps-only

loc:
	loc

