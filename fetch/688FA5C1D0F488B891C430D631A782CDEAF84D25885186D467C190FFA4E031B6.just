# gRPC compile with Reactor code generation
grpc-compile:
   mvn protobuf:compile

# build project
build: grpc-compile
   mvn -DskipTests clean package

# testing with evans
testing:
   evans src/test/proto/greeter.proto