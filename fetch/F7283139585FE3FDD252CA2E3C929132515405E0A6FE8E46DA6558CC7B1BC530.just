@run-release: release
	cargo run

@run: build
	cargo run

@release:
	cargo build --release
	just copy-resources release

@build:
	cargo build
	just copy-resources debug

@copy-resources debug-or-release:
	Copy-Item -Path ./resources/* -Destination ./target/{{debug-or-release}}/resources/
