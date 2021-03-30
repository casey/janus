# Build with Profile Guided Optimizations
pgo:
	@# STEP 0: Make sure there is no left-over profiling data from previous runs
	@rm -rf /tmp/pgo-data
	@cargo clean

	@# STEP 1: Build the instrumented binaries
	@env RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo +nightly build --release --target=x86_64-unknown-linux-gnu

	@# STEP 2: Run the instrumented binaries with some typical data
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://google.com/
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://github.com/
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://gitlab.com/
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://reddit.com/r/rust
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://reddit.com/r/neovim
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://users.rustlang.org/
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://dev.lemmy.ml/community
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://www.google.com/
	@./target/x86_64-unknown-linux-gnu/release/markdown_link https://mozilla.com/

	@# STEP 3: Merge the `.profraw` files into a `.profdata` file
	@llvm-profdata merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data

	@# STEP 4: Use the `.profdata` file for guiding optimizations
	@RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata -C target-cpu=native -C link-arg=-s" cargo +nightly build --release --target=x86_64-unknown-linux-gnu
	@sudo rm -dR target/release
