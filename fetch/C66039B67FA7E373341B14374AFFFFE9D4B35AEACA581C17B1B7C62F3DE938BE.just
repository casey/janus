list:
    @just -l

gen:
    cd src/pb && protoc -I. -Iinclude --rust_out=. --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_rust_plugin` *.proto

run:
    cargo run --example put
