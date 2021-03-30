# rsocket client test
test:
  rsc ws://localhost:8080/~rsocket --request --route request-response -d Jackie --debug

# native build
native-build:
   mvn -Pnative -DskipTests clean package
   upx -7 -k target/rsocket-graal-demo

# native build with buildpacks
buildpacks-native:
   mvn -PbuildpacksNative -DskipTests spring-boot:build-image

# run native image agent to generate related configuration files
native-assist:
  mkdir -p target/native-image
  java -agentlib:native-image-agent=config-output-dir=./target/native-image/ -jar target/rsocket-graal-demo.jar