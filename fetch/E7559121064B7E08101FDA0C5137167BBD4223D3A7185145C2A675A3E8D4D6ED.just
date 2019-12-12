build:
    cargo build --all
clean:
    cargo clean
test:
    cargo test --all
clippy:
    cargo clippy --all --all-targets
pedantic:
    cargo clippy --all --all-targets --features pedantic
update:
    cargo update
bloat:
    cargo bloat
cbuild: clean build
ctest: clean test
precommit:
    scripts/validate.sh
rustfmt:
    cargo fmt --all -- --check
alias fmt := rustfmt
check: rustfmt update test clippy
fixlock:
    rm Cargo.lock
    cargo update

branch := "develop"
merge_request:
    git push -o merge_request.create -o merge_request.target={{branch}}
alias mr := merge_request
