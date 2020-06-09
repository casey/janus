cortexm_core := 'cortexm4f_r0p1'
stm32_mcu := 'stm32l4s9'
export DRONE_RUSTFLAGS := '--cfg cortexm_core="' + cortexm_core + '" ' + '--cfg stm32_mcu="' + stm32_mcu + '"'
target := 'thumbv7em-none-eabihf'
features := 'adc dma exti gpio i2c rtc spi tim uart'

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
	cargo clippy --package drone-stm32-map-svd
	drone env {{target}} -- cargo clippy --features "{{features}}" --all --exclude drone-stm32-map-svd

# Build the documentation
doc:
	cargo doc --package drone-stm32-map-svd
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-stm32-map

# Open the documentation in a browser
doc-open: doc
	drone env {{target}} -- cargo doc --features "{{features}}" --package drone-stm32-map --open

# Run the tests
test:
	drone env -- cargo test --features "{{features}} std" --package drone-stm32-map

# Test all MCUs
test-all:
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f100"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f101"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f102"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f103"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f107"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f401"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f405"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f407"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f410"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f411"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f412"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f413"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f427"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f429"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f446"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f469"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x1"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x2"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x3"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x5"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x6"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r5"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s5"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r7"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s7"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r9"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s9"' drone env -- cargo test --package drone-stm32-map --features "{{features}} std"

# Update README.md
readme:
	cargo readme -o README.md

# Bump the versions
version-bump version drone-core-version drone-cortexm-version drone-svd-version:
	sed -i "s/\(api\.drone-os\.com\/drone-stm32-map\/\)[0-9]\+\(\.[0-9]\+\)\+/\1$(echo {{version}} | sed 's/\(.*\)\.[0-9]\+/\1/')/" \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml svd/Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml svd/Cargo.toml
	sed -i '/\[.*\]/h;/version = "=.*"/{x;s/\[.*drone-stm32-map-.*\]/version = "={{version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-core\]/version = "{{drone-core-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-cortexm\]/version = "{{drone-cortexm-version}}"/;t;x}' \
		Cargo.toml src/pieces/*/Cargo.toml src/pieces/Cargo.toml src/periph/*/Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-svd\]/version = "{{drone-svd-version}}"/;t;x}' \
		svd/Cargo.toml
	sed -i 's/\(drone-stm32-map.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
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
	cd src/periph/adc && drone env {{target}} -- cargo publish
	cd src/periph/dma && drone env {{target}} -- cargo publish
	cd src/periph/exti && drone env {{target}} -- cargo publish
	cd src/periph/gpio && drone env {{target}} -- cargo publish
	cd src/periph/i2c && drone env {{target}} -- cargo publish
	cd src/periph/rtc && drone env {{target}} -- cargo publish
	cd src/periph/spi && drone env {{target}} -- cargo publish
	cd src/periph/tim && drone env {{target}} -- cargo publish
	cd src/periph/uart && drone env {{target}} -- cargo publish
	sleep 30
	drone env {{target}} -- cargo publish --features "{{features}}"

# Publish the docs to api.drone-os.com
publish-doc: doc
	dir=$(sed -n 's/.*api\.drone-os\.com\/\(.*\/.*\)\/.*\/"/\1/;T;p' Cargo.toml) \
		&& rm -rf ../drone-api/$dir \
		&& cp -rT target/doc ../drone-api/$dir \
		&& cp -rT target/{{target}}/doc ../drone-api/$dir \
		&& echo '<!DOCTYPE html><meta http-equiv="refresh" content="0; URL=./drone_stm32_map">' > ../drone-api/$dir/index.html \
		&& cd ../drone-api && git add $dir && git commit -m "Docs for $dir"
