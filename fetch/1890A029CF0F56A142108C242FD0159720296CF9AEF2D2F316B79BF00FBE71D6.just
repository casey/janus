cortexm_core := 'cortexm4f_r0p1'
stm32_mcu := 'stm32f401'
export DRONE_RUSTFLAGS := '--cfg cortexm_core="' + cortexm_core + '" ' + '--cfg stm32_mcu="' + stm32_mcu + '"'
target := 'thumbv7em-none-eabihf'

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
	drone env {{target}} -- cargo clippy

# Build the documentation
doc:
	drone env {{target}} -- cargo doc

# Open the documentation in a browser
doc-open: doc
	drone env {{target}} -- cargo doc --open

# Run the tests
test:
	drone env -- cargo test --features "std drone-stm32-map/gpio"

# Update README.md
readme:
	cargo readme -o README.md
