build:
    @cargo build --release
    @cp target/asmjs-unknown-emscripten/release/*.js docs/.
