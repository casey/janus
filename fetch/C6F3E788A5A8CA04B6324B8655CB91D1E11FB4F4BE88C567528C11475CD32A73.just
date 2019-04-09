runbuilder = "docker run -it -v `pwd`:/go/src/grpc-gateway_test openpitrix/openpitrix-builder:release-v0.2.3"


list:
    @just -l

builder-debug:
    {{runbuilder}} sh

gen:
    {{runbuilder}} /go/src/grpc-gateway_test/pb/generate.sh

server:
    go run cmd/server/main.go

client:
    go run cmd/client/main.go

gw:
    go run cmd/gateway/main.go
