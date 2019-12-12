export GRAALVM_HOME := "/Users/linux_china/.jenv/candidates/java/graalvm-19.2.0.1"

build:
  mvn -DskipTests clean package

native_build:
  mvn -Pnative -DskipTests clean package

docker_build:
  mvn -DskipTests clean package -Pnative -Dnative-image.docker-build=true
  docker build -f src/main/docker/Dockerfile -t linuxchina/quarkus-demo .

docker_run:
  docker run -i --rm -p 8080:8080 linuxchina/quarkus-demo

debug:
  mvn compile quarkus:dev -Ddebug=true