cortexm_core := 'cortexm4f_r0p1'
stm32_mcu := 'stm32l4s9'
export DRONE_RUSTFLAGS := '--cfg cortexm_core="' + cortexm_core + '" ' + '--cfg stm32_mcu="' + stm32_mcu + '"'
target := 'thumbv7em-none-eabihf'
features := 'adc dma gpio i2c spi tim uart'

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
	drone env {{target}} -- cargo clippy --features "{{features}}"

# Check all MCUs
lint-all:
	rustup target add thumbv7m-none-eabi
	rustup target add thumbv7em-none-eabihf
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f100"' drone env thumbv7m-none-eabi -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f101"' drone env thumbv7m-none-eabi -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f102"' drone env thumbv7m-none-eabi -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f103"' drone env thumbv7m-none-eabi -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm3_r1p1" --cfg stm32_mcu="stm32f107"' drone env thumbv7m-none-eabi -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f401"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f405"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f407"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f410"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f411"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f412"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f413"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f427"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f429"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f446"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32f469"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x1"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x2"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x3"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x5"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4x6"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r5"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s5"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r7"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s7"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4r9"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"
	DRONE_RUSTFLAGS='--cfg cortexm_core="cortexm4f_r0p1" --cfg stm32_mcu="stm32l4s9"' drone env thumbv7em-none-eabihf -- cargo check --package drone-stm32-drv --features "{{features}}"

# Build the documentation
doc:
	drone env {{target}} -- cargo doc --features "{{features}}"

# Open the documentation in a browser
doc-open: doc
	drone env {{target}} -- cargo doc --features "{{features}}" --open

# Run the tests
test:
	drone env -- cargo test --features "{{features}} std"

# Update README.md
readme:
	cargo readme -o README.md

# Bump the versions
version-bump version drone-core-version drone-cortexm-version drone-stm32-map-version:
	sed -i "s/\(docs\.rs\/drone-stm32-drv\/\)[0-9]\+\(\.[0-9]\+\)\+/\1$(echo {{version}} | sed 's/\(.*\)\.[0-9]\+/\1/')/" \
		Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-core\]/version = "{{drone-core-version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-cortexm\]/version = "{{drone-cortexm-version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*drone-stm32-map\]/version = "{{drone-stm32-map-version}}"/;t;x}' \
		Cargo.toml
	sed -i 's/\(drone-stm32-drv.*\)version = "[^"]\+"/\1version = "{{version}}"/' \
		src/lib.rs

# Publish to crates.io
publish:
	drone env {{target}} -- cargo publish --features "{{features}}"
