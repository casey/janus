standard_flags = "-L compiler/Parser/debug/ -lParserTest -s EXPORTED_FUNCTIONS=['_interpret','_parse','_format_asm'] -s MODULARIZE=1 -s EXPORT_NAME='SysProg'"
debug_flags = standard_flags + " -g -s ASSERTIONS=2 -s DEMANGLE_SUPPORT=1 -s SAFE_HEAP=1"
release_flags = standard_flags + " -O3"
wasm_flags = "-s BINARYEN_METHOD='native-wasm'"

build:
    cargo rustc --release --target asmjs-unknown-emscripten -- -C link-args="{{release_flags}}"
    @cp target/asmjs-unknown-emscripten/release/*.js* docs/.

debug:
    cargo rustc --target asmjs-unknown-emscripten -- -C link-args="{{debug_flags}}"
    @cp target/asmjs-unknown-emscripten/debug/*.js* docs/.

wasm:
    cargo rustc --release --target wasm32-unknown-emscripten -- -C link-args="{{release_flags}}"
    @cp target/wasm32-unknown-emscripten/release/*.js* docs/.
    @cp target/wasm32-unknown-emscripten/release/*.wasm* docs/.

cpp:
    make -C compiler
