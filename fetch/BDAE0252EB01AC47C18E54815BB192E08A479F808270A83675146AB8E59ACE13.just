run LOGLEVEL="info":
  RUST_LOG={{LOGLEVEL}} cargo run

test:
  RUST_BACKTRACE=1 cargo test -- --nocapture
testonly PATTERN:
  RUST_BACKTRACE=1 cargo test --lib {{PATTERN}} -- --nocapture

debug TEST:
  cargo test --test {{TEST}} --features debug

check:
  cargo check
outdated:
  cargo outdated
update:
  cargo update
  @just outdated
updateonly CRATE:
  cargo update -p {{CRATE}}
  @just outdated

@bench: nightly
  cargo bench
  just stable

@nightly:
  rustup override add nightly 2> /dev/null > /dev/null

@stable:
  rustup override remove 2> /dev/null

@lint: nightly
  cargo install clippy 2> /dev/null || exit 0
  cargo clippy
  just stable

doc:
  cargo doc
showdoc:
  cargo doc --open


name = `sed -En 's/name[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml`
version = `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/\1/p' Cargo.toml`

release:
	cargo build --release
	strip target/release/operator

# publish new version
publish:
  # check that active branch is master
  git branch | grep '* master'
  # check that everything is committed
  git diff --no-ext-diff --quiet --exit-code
  # create new version branch
  git checkout -b {{version}}
  git push --all
  # publish crate
  cargo publish
  # create distribution files
  @mkdir -p dist
  cargo build --release --target x86_64-unknown-linux-gnu
  @cp target/x86_64-unknown-linux-gnu/release/operator dist/{{name}}-{{version}}-x86_64-unknown-linux-gnu

clean:
	cargo clean
	find . -type f -name "*.orig" -exec rm {} \;
	find . -type f -name "*.bk" -exec rm {} \;
	find . -type f -name ".*~" -exec rm {} \;
