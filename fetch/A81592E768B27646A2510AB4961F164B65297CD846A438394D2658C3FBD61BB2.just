dev := '--dev'

wasm:
	cd client && wasm-pack build {{dev}}
dist: wasm
	cd client/www && npm run build
serve: dist
	sfz -r client/www/dist
npm:
	cd client/www && npm install
