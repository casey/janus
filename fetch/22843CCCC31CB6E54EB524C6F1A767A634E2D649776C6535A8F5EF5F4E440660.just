run:
    cargo build && RUST_LOG=info ./target/debug/handlebars-renderer -i ./templates/input.tmpl -o ./output -v values.json
