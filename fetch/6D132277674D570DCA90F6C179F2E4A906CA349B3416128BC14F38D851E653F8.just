watch:
	cargo watch -x fmt -x test

serve:
	cd static && ../bin/serve

wat target:
	wat2wasm wat/{{target}}.wat -o wat/{{target}}.wasm
	wasm-interp wat/{{target}}.wasm --run-all-exports --host-print
