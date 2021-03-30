doc:
    cargo doc --document-private-items

doc-open:
    cargo doc --document-private-items --open

watch:
    cargo watch -x 'clippy --all --all-features'

run:
    cargo run -- --log-file output.log

tail:
    tail -f output.log
