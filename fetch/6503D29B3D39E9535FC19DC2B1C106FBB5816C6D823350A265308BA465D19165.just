name = "kreida-wasm-chart"
name2 = "kreida_wasm_chart"
target = "../../target/wasm32-unknown-emscripten"

build:
	mkdir -p out
	rm -rf {{target}}/release/deps/{{name}}.js
	rm -rf {{target}}/release/deps/{{name2}}.wasm

	cargo build --release --target=wasm32-unknown-emscripten

	cp {{target}}/release/deps/{{name}}.js out/{{name}}.js
	cp {{target}}/release/deps/{{name2}}.wasm out/{{name}}.wasm
	cp assets/static/* out/

	emrun out/index.html

debug:
	mkdir -p out
	rm -rf {{target}}/debug/deps/{{name}}.js
	rm -rf {{target}}/debug/deps/{{name2}}.wasm

	cargo build --target=wasm32-unknown-emscripten

	cp {{target}}/debug/deps/{{name}}.js out/{{name}}.js
	cp {{target}}/debug/deps/{{name2}}.wasm out/{{name}}.wasm
	cp {{target}}/debug/deps/{{name2}}.wasm.map out/{{name}}.wasm.map
	cp assets/static/* out/

	emrun out/index.html
