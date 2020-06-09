
set shell := ["powershell"]

file := ""
fuzz := ""

r:
    cargo run --features "pc-debug" --example main -- {{file}}

rr:
    cargo run --example main --release -- {{file}}

c:
    cargo check

cc:
    cargo check
    cargo check --features "pc-debug"
    cargo check --features "fuzzer"
    cargo test --no-run --all-targets
    cargo test --no-run --all-targets --features "pc-debug"
    cargo test --no-run --all-targets --features "fuzzer"

ccc:
    cargo clean
    cargo clippy
    cargo build --features "pc-debug" --example main

t:
    cargo test --features "pc-debug"

tt:
    cargo run --example test_files

do:
    cargo doc --no-deps --open

f:
    cargo run --example fuzzer --features "fuzzer" -- {{fuzz}}

vl:
    cargo test --package piccolo --lib integration::very_long -- --exact --ignored
