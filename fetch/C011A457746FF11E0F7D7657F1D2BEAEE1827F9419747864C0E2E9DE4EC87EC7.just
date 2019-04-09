build:
	cargo-web build

copy: build
	cp target/wasm32-unknown-unknown/release/recognitio.js static
	cp target/wasm32-unknown-unknown/release/recognitio.wasm static

test: copy
	cargo-web start

clean:
	rm static/recognitio.js
	rm static/recognitio.wasm	
