name = "wasm_test"
exported_functions = "'_wasm_number','_wasm_string_to_rust','_wasm_string_to_js','_wasm_array_to_js','_wasm_array_to_rust'"

build:
	mkdir -p wasm
	cargo rustc --release \
	--target=wasm32-unknown-emscripten -- \
	-C link-args="-s EXPORTED_FUNCTIONS=[{{exported_functions}}]" \
	--verbose 
	cp target/wasm32-unknown-emscripten/release/{{name}}.js wasm/{{name}}.js
	cp target/wasm32-unknown-emscripten/release/deps/{{name}}-*.wasm wasm/{{name}}.wasm
