name := 'plasma_web'
target_dir := 'target/wasm32-unknown-unknown/release/'
features := env_var_or_default('FEATURES', "")
node_env := env_var_or_default('NODE_ENV', "production")

# build and optimize wasm files
all: wasm opt

# install npm deps
install:
    npm install

# compile and serve
serve: wasm
    npm run serve

# create distribution files
webpack:
    NODE_ENV={{node_env}} npx webpack

# build wasm and bindgen files
wasm: build bindgen

# build wasm files
build:
    cargo +nightly build --lib --release --package plasma-web --features={{features}}

# take only what we need and create some polyfills in js
bindgen:
    wasm-bindgen --typescript --remove-name-section --remove-producers-section --out-dir . ../{{target_dir}}{{name}}.wasm

# make the binary *even smaller* if you installed `wasm-opt`
opt:
    wasm-opt -O3 {{name}}_bg.wasm -o {{name}}_bg.wasm

# clean cargo build
clean:
    cargo clean
    rm -f {{name}}.js
    rm -f {{name}}.d.ts
    rm -f {{name}}_bg.d.ts
    rm -f {{name}}_bg.wasm

# remove all compiled files from static
distclean: clean
    rm -f {{name}}.tar.bz2
    rm -rf dist

# gzip all files in static for distribution
gzip:
    for file in dist/*.{css,js,map,html,wasm}; do \
      gzip -9 -c "$file" >"$file".gz && touch -r "$file" "$file".gz; \
    done

# prepare distribution tar
pack:
    tar -cvjf {{name}}.tar.bz2 dist

# create distribution files and pack them
dist: all webpack gzip pack

# generate TypeScript documentation
doc:
  npx typedoc --tsconfig tsconfig.json
