build:
  cargo +nightly build --release

run: build
  cp target/release/librupy.so python/rupy.so
  cd python && python test1.py
