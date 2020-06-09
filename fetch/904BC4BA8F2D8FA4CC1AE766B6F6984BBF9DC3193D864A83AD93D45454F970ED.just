cortexm_core := 'cortexm4f_r0p1'
stm32_mcu := 'stm32f401'
export DRONE_RUSTFLAGS := '--cfg cortexm_core="' + cortexm_core + '" ' + '--cfg stm32_mcu="' + stm32_mcu + '"'

# Install dependencies
deps:
	rustup component add clippy
	rustup component add rustfmt
	type cargo-readme >/dev/null || cargo +stable install cargo-readme

# Reformat the source code
fmt:
	cargo fmt

# Check the source code for mistakes
lint:
	cargo clippy

# Build the documentation
doc:
	cargo doc

# Open the documentation in a browser
doc-open: doc
	cargo doc --open

# Run the tests
test:
	drone env -- cargo test --features "std drone-cortexm/std drone-stm32-map/std smartoris-i2c/std"

# Update README.md
readme:
	cargo readme -o README.md
