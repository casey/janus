TARGET_DIR := `cargo metadata --no-deps --format-version 1 | jq '.target_directory'`

default_output := 'Html'
default_feature := 'manual-iter'
default_bench_name := 'compare_stdpath'

test feature=default_feature:
    cargo test --all --no-default-features --features {{feature}}

cov output=default_output:
    cargo tarpaulin -v -o {{output}} --exclude-files src/unix/windows_iter.rs src/windows/path.rs src/windows/windows_iter.rs src/windows/iter/parser.rs src/unix/iter/parser.rs tests/*

cov-parser-iter output=default_output:
    cargo tarpaulin -v -o {{output}} --no-default-features --features parser-iter --exclude-files src/unix/windows_iter.rs src/windows/path.rs src/windows/windows_iter.rs src/windows/iter/manual.rs src/unix/iter/manual.rs tests/*

kcov:
    #!/usr/bin/bash
    mkdir -p {{TARGET_DIR}}/debug {{TARGET_DIR}}/cov
    rm -rf {{TARGET_DIR}}/debug/pathlib-* {{TARGET_DIR}}/cov/*
    cargo test --no-run
    EXEC_FILE=$(ls {{TARGET_DIR}}/debug/pathlib-* | sed '/[.]d$/d')
    kcov --include-path src --exclude-path src/test {{TARGET_DIR}}/cov $EXEC_FILE

bench-feature-iter:
    cargo bench --all-features --bench compare_iter

bench name=default_bench_name:
    cargo bench --bench {{name}}
