rbt := "RUST_BACKTRACE=1"
config := "./karabinux/tests/config/empty.json"

# Builds the project.
build:
	cargo build

# Builds the project with `--features viewer`.
build-features-viewer:
	cargo build --features viewer

# Runs the project's tests.
test:
	cargo test --all

# Formats the project.
fmt:
	cargo fmt --all
	cargo clippy --all-targets --all-features

# Checks the format of the project.
fmt-check:
	cargo fmt --all -- --check
	cargo clippy --all-targets --all-features -- -D warnings

# Runs karabinux with default config with the given device.
run device: build _sudo
	sudo {{rbt}} ./target/debug/karabinux -g -d "{{device}}" -c "{{config}}"

# Same as `run`, but also activates the event viewer.
view device: build-features-viewer _sudo
	sudo {{rbt}} ./target/debug/karabinux -v -g -d "{{device}}" -c "{{config}}"

# Publishes all the packages in the workspace.
publish: build build-features-viewer fmt-check test
	cargo publish --manifest-path ./Cargo.toml
	cargo publish --manifest-path ./karabinux/Cargo.toml

# Prompt for sudo (required to create a virtual `libevdev_uinput` device).
@_sudo:
	sudo -v
