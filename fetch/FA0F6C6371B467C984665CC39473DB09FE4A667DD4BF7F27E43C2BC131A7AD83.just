alias m := Measure
alias t := Test
alias c := Compare
alias b := Build
alias r := Run

all := ' '


# Measure performace with hyperfine
Measure: Build
    @hyperfine target/release/fetch

# Run test (add parameter to run specific test)
Test tests=all:
    @cargo test {{tests}}

# Test and capture output
cap tests=all:
    @cargo test {{tests}} -- --nocapture

# Compare Output with neofetch
Compare:
    @neofetch --off --color_blocks off
    @target/release/fetch

# Cleans Cargo Cache
Clean:
	@cargo clean

# Builds Fetch
Build:
	@cargo build --release

# Builds & Runs Fetch
Run: Build
	@cargo run --release

# Checks Code Quality Before Pushing to GH
Push: 
	@cargo fmt --all
	@cargo build --verbose --all
	@cargo test --verbose --all
	