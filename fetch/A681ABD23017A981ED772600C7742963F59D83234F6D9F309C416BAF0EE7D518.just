# run clippy
clip:
	@cargo clippy
# run application
run:
	@cargo run
#output default rustfmt.toml
form:
	@rustfmt --print-config default rustfmt.toml
	@echo "Saved rustfmt config."
#delete logs
dlog:
	@rm -v *.log
	@echo "All log files removed."
# build specs
build:
	@cargo build
#build and test
test: build
	@cargo test -- --nocapture
#format Rust code
rfmt:
	@rustfmt -q --emit files src/**/*.rs
	@echo "Formatted Rust code."
#generate changelog
clog:
	@changelog -vP -o CHANGELOG.md
# clean ALL artifacts
clean:
	@echo "Removing all build artifacts..."
	@rm -rf **/target
	@echo "Removing all Rust source files..."
	@rm -Rv src/**/*.rs
	@cargo clean -q
toke:
	@tokei
# So vim can handle justfile like Makefile syntax
# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
