copy_mylib: build
  cp -rf mylib/target/debug/libmylib.dylib ~/Library/Java/Extensions/

build:
  (cd mylib && cargo build)

generate:
  javac -h . src/main/java/org/mvnsearch/RustService.java

clean:
  rm  ~/Library/Java/Extensions/libmylib.dylib