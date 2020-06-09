dev := '--dev'

check: execk wasmck
build: exe wasm
test: exetest wasmtest

execk:
	cd games/ffa && cargo check $([ x"{{dev}}" = x"--dev" ] || echo "--release") --target-dir=../../target
exe:
	cd games/ffa && cargo build $([ x"{{dev}}" = x"--dev" ] || echo "--release") --target-dir=../../target
exetest:
	cd games/ffa && cargo test $([ x"{{dev}}" = x"--dev" ] || echo "--release") --target-dir=../../target
server:
	cd games/ffa && cargo run $([ x"{{dev}}" = x"--dev" ] || echo "--release") --target-dir=../../target

wasmck:
	cd client && wasm-pack build {{dev}}
wasm:
	cd client && wasm-pack build {{dev}}
wasmtest:
	cd client && wasm-pack test $([ x"{{dev}}" = x"--dev" ] || echo "--release") --firefox
dist: wasm
	cd client/site && npm run build
client: dist
	sfz -r client/site/dist
npm:
	cd client/site && npm install
