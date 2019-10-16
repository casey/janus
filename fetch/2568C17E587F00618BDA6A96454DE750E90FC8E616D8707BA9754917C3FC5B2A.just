all: test run

run:
  cargo run

test:
  cargo test

watch:
  fd | entr -rcs "echo '' | cargo test"
