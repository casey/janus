build:
  cargo +nightly build --release

run: build
  cp target/release/libpyargmin.so python/pyargmin.so
  cd python && python test1.py
