do-frontend:
  yarn frontend/build
  cp frontend/dist/* static/
  cp frontend/assets/* static/
  cp wasm-experiment/target/wasm32-unknown-unknown/release/*.js static/
  cp wasm-experiment/target/wasm32-unknown-unknown/release/*.wasm static/

watch-frontend:
  yarn frontend/watch

compile-go:
  go build

start-postgres:
  sudo systemctl start postgresql

watch:
  watchexec -c --exts rs,hbs,fluent --restart "cargo run"

write-schema:
  diesel print-schema > src/db/schema.rs
