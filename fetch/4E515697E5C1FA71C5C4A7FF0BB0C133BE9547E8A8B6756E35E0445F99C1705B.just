run-basic url:
    RUST_LOG=evntsrc_client=debug cargo watch -x 'run --example basic {{url}}'
