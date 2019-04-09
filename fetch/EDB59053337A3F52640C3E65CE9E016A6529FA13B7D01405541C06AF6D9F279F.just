# Compile proto files for the Rust server
codegen:
    protoc \
        --plugin=protoc-gen-grpc=`which grpc_rust_plugin` \
        --rust_out=src/rpc \
        --grpc_out=src/rpc \
        proto/*
    protoc \
      --plugin=protoc-gen-ts=./frontend/node_modules/.bin/protoc-gen-ts \
      --js_out=import_style=commonjs,binary:frontend/src/rpc \
      --ts_out=service=true:frontend/src/rpc \
      -I ./proto \
      proto/*.proto
    protoc \
      --js_out=import_style=commonjs,binary:gql-proxy/src/rpc \
      -I ./proto \
      proto/*.proto
    grpc_tools_node_protoc \
      --js_out=import_style=commonjs,binary:gql-proxy/src/rpc \
      --grpc_out=gql-proxy/src/rpc \
      --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` \
      proto/*.proto

start-proxy:
  grpcwebproxy \
    --backend_addr=localhost:4443 \
    --server_http_tls_port=4444 \
    --server_tls_cert_file=etc/localhost.crt \
    --server_tls_key_file=etc/localhost.key \
    --backend_tls=false

diesel-print-schema:
  diesel print-schema > src/db_schema.rs

test:
  DATABASE_URL="postgres://postgres@localhost:5432/yacchauyo_test" \
    diesel database reset
  YACCHAUYO_DATABASE_URL="postgres://postgres@localhost:5432/yacchauyo_test" \
    cargo test

watch:
  watchexec \
    -s SIGKILL \
    --restart \
    --clear \
    --exts html,rs \
    cargo run

tmux-setup:
  sudo systemctl start postgresql
  tmux split-window just start-proxy
  tmux split-window cargo run rpc
  tmux new-window -n frontend -c `pwd`/frontend yarn start
  tmux split-window -h -c `pwd`/frontend -t frontend yarn run test --watch
  tmux split-window -c `pwd`/frontend -t frontend yarn run typecheck
