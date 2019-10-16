ghp_branch:='gh-pages'
index_redirect_html:='<html><head><meta http-equiv="refresh" content="0; url=plasma/index.html"></head><body><a href="plasma/index.html">Redirect</a></body></html>'

# Checkout github pages branch into ghp directory
co-ghp:
  mkdir {{ghp_branch}}
  cd {{ghp_branch}}
  git init
  git remote add -t {{ghp_branch}} -f origin git@github.com:royaltm/rust-plasma.git
  git checkout {{ghp_branch}}

# generate documentation
doc: cargo-doc ts-doc

# generate documentation and udpate github pages directory
update-ghp: doc
  just web/webpack
  mkdir -p ghp/master
  rsync -rvah --delete target/doc/ ghp/master/rust
  @echo '{{index_redirect_html}}' >ghp/master/rust/index.html
  rsync -rvah --delete web/doc/ ghp/master/ts
  rm -rf ghp/*.wasm
  rsync -rvah --include '*.js' --include '*.wasm' --exclude '*' web/dist/ ghp

# generate Rust documentation
cargo-doc:
  cargo doc --no-deps -p plasma

# generate TypeScript documentation
ts-doc:
  just web/all
  just web/doc

test:
  just plasma/test

bench:
  just plasma/bench

clean:
  cargo clean
