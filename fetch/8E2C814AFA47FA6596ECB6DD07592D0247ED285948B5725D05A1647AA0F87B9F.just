install:
  cargo install --force --path .

watch:
  cargo watch -cs 'cargo test -- --nocapture'
