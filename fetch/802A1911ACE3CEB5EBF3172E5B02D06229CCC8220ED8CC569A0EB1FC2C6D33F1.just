prefix := "/usr/local"

release:
	cd pesc-cli && cargo build --release

debug:
	cd pesc-cli && cargo build

docs:
	cd docs && scdoc < pesc.7.scd > pesc.7
	cd docs && scdoc < pescli.1.scd > pescli.1

unit-tests:
	cd pesc-cli && cargo test
	cd pesc-lib && cargo test

install: release docs
	install -Dm755 pesc-cli/target/release/pescli {{prefix}}/bin/pescli
	install -Dm644 docs/pescli.1 {{prefix}}/share/man/man1/pescli.1
	install -Dm644 docs/pesc.7   {{prefix}}/share/man/man7/pesc.7
