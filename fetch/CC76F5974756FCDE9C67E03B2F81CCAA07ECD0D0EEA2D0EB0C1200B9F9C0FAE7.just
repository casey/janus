run:
    wat2wasm fib.wat -o fib.wasm
    wasm-interp fib.wasm --run-all-exports --host-print
