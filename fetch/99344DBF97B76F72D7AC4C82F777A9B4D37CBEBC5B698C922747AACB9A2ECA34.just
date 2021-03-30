default:
  cargo check

test:
  cargo test

alias t := test

docs:
  cargo doc --no-deps
  miniserve target/doc

clippy:
  docker run -ti --rm -v `pwd`:/srv rustlang/rust:nightly bash -c "cd /srv && cargo clippy"
