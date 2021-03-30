build:
  wasm-pack build --release --target=web
  rm -rf static/pkg/
  mv pkg static/

serve: build
  npx firebase serve

deploy: build
  npx firebase deploy --only hosting
