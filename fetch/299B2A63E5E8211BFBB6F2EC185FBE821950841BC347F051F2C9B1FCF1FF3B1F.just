default: test

check:
  cargo check

run:
  rm -rf tmp
  mkdir tmp
  touch tmp/{foo,bar,baz}
  cargo run tmp/*
  ls tmp

test:
  cargo test