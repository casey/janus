# gRPC compile with Reactor code generation
grpc-compile:
   mvn protobuf:compile

# build project
build: grpc-compile
   mvn -DskipTests clean package

# testing with evans
testing:
   evans

services:
   grpcurl -plaintext localhost:50051 list

curl:
   grpcurl -plaintext -d '{"id": 1234}' localhost:50051 org.mvnsearch.service.AccountService/FindAccount