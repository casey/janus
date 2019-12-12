# Install dependencies
deps:
	rustup component add clippy
	rustup component add rustfmt
	type cargo-readme >/dev/null || cargo +stable install cargo-readme

# Reformat the source code
fmt:
	cargo fmt

# Check for mistakes
lint:
	cargo clippy

# Generate the docs
doc:
	cargo doc

# Open the docs in a browser
doc-open: doc
	cargo doc --open

# Run the tests
test:
	cargo test

# Update README.md
readme:
	cargo readme -o README.md

# Bump crate versions
version-bump version drone-core-version:
	sed -i "s/\(api\.drone-os\.com\/drone-svd\/\)[0-9]\+\(\.[0-9]\+\)\+/\1$(echo {{version}} | sed 's/\(.*\)\.[0-9]\+/\1/')/" \
		Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml
	sed -i 's/\(drone-svd.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
		src/lib.rs

# Publish to crates.io
publish:
	cargo publish

# Publish the docs to api.drone-os.com
publish-doc: doc
	dir=$(sed -n 's/.*api\.drone-os\.com\/\(.*\/.*\)\/.*\/"/\1/;T;p' Cargo.toml) \
		&& rm -rf ../drone-api/$dir \
		&& cp -rT target/doc ../drone-api/$dir \
		&& echo '<!DOCTYPE html><meta http-equiv="refresh" content="0; URL=./drone_svd">' > ../drone-api/$dir/index.html \
		&& cd ../drone-api && git add $dir && git commit -m "Docs for $dir"
