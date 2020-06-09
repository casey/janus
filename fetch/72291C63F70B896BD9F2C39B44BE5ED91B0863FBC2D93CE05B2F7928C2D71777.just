ci: test clippy

test:
  cargo test --color=always -- --quiet

clippy:
  cargo clippy -- --deny clippy::all
