export GRAAL_HOME := "~/.jenv/candidates/java/graalvm-19.2.0.1"

# maven build
build:
   mvn -DskipTests clean package

# native build
native_build:
   mvn -DskipTests package native-image:native-image

# docker build
docker_build:
   mvn compile jib:dockerBuild

run_with_agent:
   {{GRAAL_HOME}}/bin/java -agentlib:native-image-agent=config-output-dir=target/classes/META-INF/native-image -jar target/native-image-demo-1.0.0-SNAPSHOT-jar-with-dependencies.jar
