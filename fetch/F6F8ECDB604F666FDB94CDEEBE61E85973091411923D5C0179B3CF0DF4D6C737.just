standard_flags = "-s EXPORTED_FUNCTIONS=['_calculate'] -s MODULARIZE=1 -s EXPORT_NAME='AoC'"
debug_flags = standard_flags + " -g -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1 -s SAFE_HEAP=1"
release_flags = standard_flags + " -O3"

asmjs:
    cargo rustc --release --target asmjs-unknown-emscripten -- -C link-args="{{release_flags}}"
    @cp target/asmjs-unknown-emscripten/release/aoc.js* .

asmjs-debug:
    cargo rustc --target asmjs-unknown-emscripten -- -C link-args="{{debug_flags}}"
    @cp target/asmjs-unknown-emscripten/debug/aoc.js* .

wasm:
    cargo rustc --release --target wasm32-unknown-emscripten -- -C link-args="{{release_flags}}"
    @cp target/wasm32-unknown-emscripten/release/aoc.js .
    @cp target/wasm32-unknown-emscripten/release/aoc.wasm .
