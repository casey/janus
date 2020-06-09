cortex_m_core := 'cortex_m3_r1p0'
ti_sl_mcu := 'cc2538'
export DRONE_RUSTFLAGS := '--cfg cortex_m_core="' + cortex_m_core + '" ' + '--cfg ti_sl_mcu="' + ti_sl_mcu + '"'
target := 'thumbv7-none-eabi'
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

# Check for mistakes
lint:
	cargo clippy --package drone-ti-sl-map-svd
	drone env {{target}} -- cargo clippy --features "{{features}}" --all --exclude drone-ti-sl-map-svd

# Generate the docs
doc:
	cargo doc --package drone-ti-sl-map-svd
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-ti-sl-map

# Open the docs in a browser
doc-open: doc
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-ti-sl-map --open

# Run the tests
test:
	drone env -- cargo test --features "{{features}} std" --package drone-ti-sl-map

# Test all MCUs
test-all:
	DRONE_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p0" --cfg ti_sl_mcu="cc2538"' drone env -- cargo test --package drone-ti-sl-map --features "{{features}} std"

# Update README.md
readme:
	cargo readme -o README.md

# Bump crate versions
version-bump version drone-core-version drone-cortex-m-version drone-svd-version:
	sed -i "s/\(api\.drone-os\.com\/drone-ti-sl-map\/\)[0-9]\+\(\.[0-9]\+\)\+/\1$(echo {{version}} | sed 's/\(.*\)\.[0-9]\+/\1/')/" \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml svd/Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml svd/Cargo.toml
	sed -i '/\[.*\]/h;/version = "=.*"/{x;s/\[.*drone-ti-sl-map-.*\]/version = "={{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-core\]/version = "{{drone-core-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-cortex-m\]/version = "{{drone-cortex-m-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-svd\]/version = "{{drone-svd-version}}"/;t;x}' \
		svd/Cargo.toml
	sed -i 's/\(drone-ti-sl-map.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
		src/lib.rs

# Publish to crates.io
publish:
	cd svd && cargo publish
	sleep 5
	cd src/pieces/1 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/2 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/3 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/4 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/5 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/6 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/7 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/8 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/9 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/10 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/11 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces/12 && drone env {{target}} -- cargo publish
	sleep 5
	cd src/pieces && drone env {{target}} -- cargo publish
	sleep 5
	drone env {{target}} -- cargo publish --features "{{features}}"

# Publish the docs to api.drone-os.com
publish-doc: doc
	dir=$(sed -n 's/.*api\.drone-os\.com\/\(.*\/.*\)\/.*\/"/\1/;T;p' Cargo.toml) \
		&& rm -rf ../drone-api/$dir \
		&& cp -rT target/doc ../drone-api/$dir \
		&& cp -rT target/{{target}}/doc ../drone-api/$dir \
		&& echo '<!DOCTYPE html><meta http-equiv="refresh" content="0; URL=./drone_ti_sl_map">' > ../drone-api/$dir/index.html \
		&& cd ../drone-api && git add $dir && git commit -m "Docs for $dir"
