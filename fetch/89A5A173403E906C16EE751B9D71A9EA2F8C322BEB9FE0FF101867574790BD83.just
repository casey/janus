name = "wasm_graph"
exported_functions = "'_wasm_update_at_once','_wasm_update_loop'"

build:
	mkdir -p dist/wasm
	cargo rustc --release \
	--target=wasm32-unknown-emscripten -- \
	-C link-args="-s EXPORTED_FUNCTIONS=[{{exported_functions}}]" \
	--verbose 
	cp target/wasm32-unknown-emscripten/release/{{name}}.js dist/wasm/{{name}}.js
	cp target/wasm32-unknown-emscripten/release/deps/{{name}}-*.wasm dist/wasm/{{name}}.wasm
