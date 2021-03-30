# native build
native-build:
   mvn -Pnative -DskipTests clean package
   upx -7 -k target/ali-rsocket-graal-demo

# run native image agent to generate related configuration files
native-assist:
  mvn -DskipTests clean package
  mkdir -p target/native-image
  java -agentlib:native-image-agent=config-output-dir=./target/native-image/ -jar target/ali-rsocket-graal-demo.jar
