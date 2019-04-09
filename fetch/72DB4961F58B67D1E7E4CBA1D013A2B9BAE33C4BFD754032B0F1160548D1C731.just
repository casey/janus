TARGET_DIR = `cargo metadata --no-deps --format-version 1 | jq '.target_directory'`

cov:
    cargo tarpaulin -v -o Html --exclude-files src/unix/windows_iter.rs src/windows/path.rs src/windows/windows_iter.rs tests/*

kcov:
    #!/usr/bin/bash
    mkdir -p {{TARGET_DIR}}/debug {{TARGET_DIR}}/cov
    rm -rf {{TARGET_DIR}}/debug/pathlib-* {{TARGET_DIR}}/cov/*
    cargo test --no-run
    EXEC_FILE=$(ls {{TARGET_DIR}}/debug/pathlib-* | sed '/[.]d$/d')
    kcov --include-path src --exclude-path src/test {{TARGET_DIR}}/cov $EXEC_FILE
