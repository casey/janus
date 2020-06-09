cortexm_core := 'cortexm4f_r0p1'
tisl_mcu := 'cc2538'
export DRONE_RUSTFLAGS := '--cfg cortexm_core="' + cortexm_core + '" ' + '--cfg tisl_mcu="' + tisl_mcu + '"'
target := 'thumbv7em-none-eabihf'
features := ''

# Install dependencies
deps:
	rustup target add {{target}}
	rustup component add clippy
	rustup component add rustfmt
	type cargo-readme >/dev/null || cargo +stable install cargo-readme

# Reformat the source code
fmt:
	cargo fmt

# Check the source code for mistakes
lint:
	cargo clippy --package drone-tisl-map-svd
	drone env {{target}} -- cargo clippy --features "{{features}}" --all --exclude drone-tisl-map-svd

# Build the documentation
doc:
	cargo doc --package drone-tisl-map-svd
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-tisl-map

# Open the documentation in a browser
doc-open: doc
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-tisl-map --open

# Run the tests
test:
	drone env -- cargo test --features "{{features}} std" --package drone-tisl-map

# Test all MCUs
test-all:
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg tisl_mcu="cc2538"' drone env -- cargo test --package drone-tisl-map --features "{{features}} std"

# Update README.md
readme:
	cargo readme -o README.md

# Bump the versions
version-bump version drone-core-version drone-cortexm-version drone-svd-version:
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml svd/Cargo.toml
	sed -i '/\[.*\]/h;/version = "=.*"/{x;s/\[.*drone-tisl-map-.*\]/version = "={{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-core\]/version = "{{drone-core-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-cortexm\]/version = "{{drone-cortexm-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-svd\]/version = "{{drone-svd-version}}"/;t;x}' \
		svd/Cargo.toml
	sed -i 's/\(drone-tisl-map.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
		src/lib.rs

# Publish to crates.io
publish:
	cd svd && cargo publish
	sleep 30
	cd src/pieces/1 && drone env {{target}} -- cargo publish
	cd src/pieces/2 && drone env {{target}} -- cargo publish
	cd src/pieces/3 && drone env {{target}} -- cargo publish
	cd src/pieces/4 && drone env {{target}} -- cargo publish
	cd src/pieces/5 && drone env {{target}} -- cargo publish
	cd src/pieces/6 && drone env {{target}} -- cargo publish
	cd src/pieces/7 && drone env {{target}} -- cargo publish
	cd src/pieces/8 && drone env {{target}} -- cargo publish
	cd src/pieces/9 && drone env {{target}} -- cargo publish
	cd src/pieces/10 && drone env {{target}} -- cargo publish
	cd src/pieces/11 && drone env {{target}} -- cargo publish
	cd src/pieces/12 && drone env {{target}} -- cargo publish
	sleep 30
	cd src/pieces && drone env {{target}} -- cargo publish
	sleep 30
	drone env {{target}} -- cargo publish --features "{{features}}"
