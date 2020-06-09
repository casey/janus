# build the project
build:
   mvn -DskipTests clean package

# registry server docker build
registry_jib: build
   mvn -pl spring-boot-dubbo-registry jib:dockerBuild

# run simple registry server
simple_registry_server: build
   java -jar spring-boot-dubbo-registry/target/spring-boot-dubbo-registry-1.0.0-SNAPSHOT.jar

# run dubbo registry server
zookeeper:
  docker-compose up -d

# run dubbo server
server: build zookeeper
  java -jar -Xmx1G -Xms1G spring-boot-dubbo-server/target/spring-boot-dubbo-server-1.0.0-SNAPSHOT.jar

benchmarking_rpc:
  wrk -t5 -c50 -d30s --latency http://localhost:2080/user/2
