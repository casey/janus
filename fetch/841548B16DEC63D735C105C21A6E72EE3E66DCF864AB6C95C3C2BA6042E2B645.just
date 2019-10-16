name := 'fractx_wasm_demo'
target_dir := 'target/wasm32-unknown-unknown/release/'

# build all
all: wasm rollup

# build and optimize wasm files and copy to static
wasm: build gc opt
		cp {{target_dir}}{{name}}.gc.opt.wasm static/

# build wasm files
build:
		cargo +nightly build --lib --release

# make the binary a little smaller (working around bugs in rustc toolchain)
gc:
		wasm-gc {{target_dir}}{{name}}.wasm -o {{target_dir}}{{name}}.gc.wasm

# make the binary *even smaller* if you installed `wasm-opt`
opt:
		wasm-opt -O3 {{target_dir}}{{name}}.gc.wasm -o {{target_dir}}{{name}}.gc.opt.wasm

# rollup javascripts
rollup:
		rollup -c

watch-rollup:
		rollup -w -c

watch-wasm:
		watchexec -n -p -w src just wasm

watch-all:
		watchexec -n -p -w src just all

# clean cargo build
clean:
		cargo clean

# remove all compiled files from static
distclean: clean
		rm -f static/{{name}}.gc.opt.wasm
		rm -f static/module.js static/module.js.map
		rm -f static/master.js static/master.js.map
		rm -f static/master.js static/*.gz
		rm -f static/bootstrap.min.css
		rm -f static/popper.min.js

# gzip all files in static for distribution
gzip:
		for file in static/*.{css,js,map,html,wasm}; do \
			gzip -9 -c "$file" >"$file".gz && touch -r "$file" "$file".gz; \
		done

fetch:
		curl -f https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css -o static/bootstrap.min.css
		curl -f https://unpkg.com/popper.js@1.12.9/dist/umd/popper.min.js -o static/popper.min.js

# prepare distribution tar
pack:
		tar -cvjf {{name}}.tar.bz2 static

dist: all fetch gzip pack
