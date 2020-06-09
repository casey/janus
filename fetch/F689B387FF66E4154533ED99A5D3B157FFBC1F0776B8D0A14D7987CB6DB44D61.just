# Build the library (all features enabled)
build +flags='':
  cargo build --all-features {{flags}}

# Run Clippy (with all features)
lint:
  cargo clippy --all-features

# Run all unit tests.
test:
  cargo test --all-features

# Run all validations (UTs & Linters)
validate: lint test
