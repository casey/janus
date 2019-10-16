
build:
    protoc -I api/ api/api.proto --go_out=plugins=grpc:api
    go build ./api
    go build ./test_client
