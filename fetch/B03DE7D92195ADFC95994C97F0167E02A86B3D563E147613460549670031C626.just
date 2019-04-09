test:
	cargo-web start
	cp target/wasm32-unknown-unknown/release/hypertoss_site.js static/scripts
	cp target/wasm32-unknown-unknown/release/hypertoss_site.wasm static/scripts

build:
        cargo-web build
        cp target/wasm32-unknown-unknown/release/hypertoss_site.js static/scripts                cp target/wasm32-unknown-unknown/release/hypertoss_site.wasm static/scripts

copy:
	cp target/wasm32-unknown-unknown/release/hypertoss_site.js static/scripts
	cp target/wasm32-unknown-unknown/release/hypertoss_site.wasm static/scripts

clean:
	rm static/scripts/hypertoss_site.js
	rm static/scripts/hypertoss_site.wasm	
