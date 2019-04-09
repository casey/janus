run:
    cargo build && RUST_LOG=info target/debug/sentry --path /opt/openpitrix --etcd_endpoint 127.0.0.1:2379
