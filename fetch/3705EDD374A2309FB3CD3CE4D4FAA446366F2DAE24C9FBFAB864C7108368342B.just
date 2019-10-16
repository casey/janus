# Build with Profile Guided Optimizations
pgo:
	@# STEP 0: Make sure there is no left-over profiling data from previous runs
	@rm -rf /tmp/pgo-data
	@cargo clean

	@# STEP 1: Build the instrumented binaries
	@env RUSTFLAGS="-Cprofile-generate=/tmp/pgo-data" cargo +nightly build --release --target=x86_64-unknown-linux-gnu

	@# STEP 2: Run the instrumented binaries with some typical data
	@for file in `seq 1 100`; do ./target/x86_64-unknown-linux-gnu/release/pquote; done

	@# STEP 3: Merge the `.profraw` files into a `.profdata` file
	@llvm-profdata merge -o /tmp/pgo-data/merged.profdata /tmp/pgo-data

	@# STEP 4: Use the `.profdata` file for guiding optimizations
	@RUSTFLAGS="-Cprofile-use=/tmp/pgo-data/merged.profdata -C link-arg=-s" cargo +nightly build --release --target=x86_64-unknown-linux-gnu
