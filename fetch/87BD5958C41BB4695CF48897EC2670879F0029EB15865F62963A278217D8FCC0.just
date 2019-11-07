build: build-web
	cargo build

build-web:
	wasm-pack build web --target web
	rm web/fstree-web.tar.gz || true
	cd web/pkg && tar czf ../fstree-web.tar.gz .

run: build
	RUST_LOG=debug cargo run

web: build
	RUST_LOG=debug cargo run -- --web-only

install: build
	cargo install --path .
