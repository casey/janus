features := 'adc dma gpio i2c spi tim uart'
build_target := 'thumbv7em-none-eabihf'
cortex_m_core := 'cortex_m4f_r0p1'
stm32_mcu := 'stm32l4s9'

export CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS := '--cfg cortex_m_core="' + cortex_m_core + '" ' + '--cfg stm32_mcu="' + stm32_mcu + '"'

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

# Check each MCU
check-all:
	rustup target add thumbv7m-none-eabi
	rustup target add thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7M_NONE_EABI_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p1" --cfg stm32_mcu="stm32f100"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7m-none-eabi
	CARGO_TARGET_THUMBV7M_NONE_EABI_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p1" --cfg stm32_mcu="stm32f101"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7m-none-eabi
	CARGO_TARGET_THUMBV7M_NONE_EABI_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p1" --cfg stm32_mcu="stm32f102"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7m-none-eabi
	CARGO_TARGET_THUMBV7M_NONE_EABI_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p1" --cfg stm32_mcu="stm32f103"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7m-none-eabi
	CARGO_TARGET_THUMBV7M_NONE_EABI_RUSTFLAGS='--cfg cortex_m_core="cortex_m3_r1p1" --cfg stm32_mcu="stm32f107"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7m-none-eabi
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f401"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f405"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f407"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f410"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f411"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f412"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f413"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f427"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f429"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f446"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32f469"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4x1"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4x2"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4x3"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4x5"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4x6"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4r5"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4s5"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4r7"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4s7"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4r9"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf
	CARGO_TARGET_THUMBV7EM_NONE_EABIHF_RUSTFLAGS='--cfg cortex_m_core="cortex_m4f_r0p1" --cfg stm32_mcu="stm32l4s9"' cargo check --package drone-stm32-drv --features "{{features}}" --target thumbv7em-none-eabihf

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
version-bump version libcore-drone-version drone-core-version drone-cortex-m-version drone-stm32-map-version:
	sed -i 's/\(docs\.rs\/drone-stm32-drv\/\)[0-9]\+\(\.[0-9]\+\)\+/\1{{version}}/' \
		Cargo.toml src/lib.rs
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[package\]/version = "{{version}}"/;t;x}' \
		Cargo.toml
	sed -i '/\[.*\]/h;/version = ".*"/{x;s/\[.*\.core\]/version = "{{libcore-drone-version}}"/;t;x}' \
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
