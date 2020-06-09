# shows the list of available commands
help:
	just --list

# starts process that on every file change checks the files for errors and runs all tests
watch:
	cargo watch -x check -x test

# execute `cargo clippy`
clippy:
	cargo clippy

# execute `cargo fix`
fix:
	cargo fix
