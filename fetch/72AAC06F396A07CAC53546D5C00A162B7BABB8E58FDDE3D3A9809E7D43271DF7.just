try-codegen:
    cargo install --path=../.. --force
    protoc \
      --plugin=protoc-gen-apollo=`which protoc-gen-apollo` \
      --apollo_out=. \
      *.proto

