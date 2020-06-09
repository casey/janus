test:
    cargo test --verbose
    cargo test --verbose --features "key_encoding"

check: check-fmt check-clippy check-docs

check-fmt:
    cargo fmt -- --check

check-clippy:
    cargo clippy --verbose --all-targets --all-features -- --verbose -D warnings

check-docs:
    cargo doc --verbose

fix: fix-fmt

fix-fmt:
    cargo fmt

nightly-clippy:
    rustup run nightly -- cargo clippy --verbose --all-targets --all-features -- --verbose -D warnings

nightly-fix-fmt:
    rustup run nightly -- cargo fmt

nightly-check-fmt:
    rustup run nightly -- cargo fmt -- --check
