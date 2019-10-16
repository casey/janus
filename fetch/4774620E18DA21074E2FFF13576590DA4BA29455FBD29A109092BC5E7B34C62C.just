export KOTLIN_NATIVE_HOME := "~/.konan/kotlin-native-macos-1.3.50"

build: jsinterop
  ./gradlew build

run:
  npx live-server --watch=build/bin/native,index.html

jsinterop:
  {{KOTLIN_NATIVE_HOME}}/bin/jsinterop -pkg kotlinx.interop.wasm.dom  -o build/klib/kotlinx.interop.wasm.dom-jsinterop.klib -target wasm32