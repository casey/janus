export GRAAL_HOME := "~/.jenv/candidates/java/graalvm-19.2.0.1"

# maven build
build:
   mvn -DskipTests clean package

# native build
native_build:
   mvn -DskipTests clean package native-image:native-image

run_with_agent:
   mkdir -p target/classes/META-INF/native-image
   {{GRAAL_HOME}}/bin/java -agentlib:native-image-agent=config-output-dir=target/classes/META-INF/native-image -jar target/jscheme-1.0.0-SNAPSHOT.jar
