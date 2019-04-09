# gRPC compile with Reactor code generation
grpc-compile:
   mvn protobuf:compile

# build project
build: grpc-compile
   mvn -DskipTests clean package

# testing with evans
testing:
   echo '1' | evans -r --call FindById

# testing with evans
testing_findAll:
   echo '{ "pattern": "nick" }' | evans -r --call FindAll
