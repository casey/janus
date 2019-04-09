all: build zip

build:
	@echo '- building'
	@cargo build --release --target x86_64-unknown-linux-musl

zip:
	@echo '- zipping'
	@zip -j mdbda.zip ./target/x86_64-unknown-linux-musl/release/bootstrap