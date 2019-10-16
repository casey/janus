build_target := 'thumbv7em-none-eabihf'
features := 'stm32l4s9'

# Install dependencies
deps:
	rustup target add {{build_target}}
	rustup component add clippy
	rustup component add rustfmt
	rustup component add rls rust-analysis rust-src
	type cargo-readme >/dev/null || cargo +stable install cargo-readme

# Reformat the source code
fmt:
	cargo fmt

# Check for mistakes
lint:
	cargo clippy --target {{build_target}} --features "{{features}}"

# Generate the docs
doc:
	cargo doc --target {{build_target}} --features "{{features}}"

# Open the docs in a browser
doc-open: doc
	cargo doc --target {{build_target}} --features "{{features}}" --open

# Run the tests
test:
	cargo test --features "{{features}} std"

# Update README.md
readme:
	cargo readme -o README.md

# Bump crate versions
version-bump version drone-core-version drone-cortex-m-version drone-stm32-map-version:
	sed -i 's/\(docs\.rs\/drone-stm32-drv\/\)[0-9]\+\(\.[0-9]\+\)\+/\1{{version}}/' \
		Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-core\]/version = "{{drone-core-version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-cortex-m\]/version = "{{drone-cortex-m-version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-stm32-map\]/version = "{{drone-stm32-map-version}}"/;t;x}' \
		Cargo.toml
	sed -i 's/\(drone-stm32-drv.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
		src/lib.rs

# Publish to crates.io
publish:
	cargo publish --target {{build_target}} --features "{{features}}"
