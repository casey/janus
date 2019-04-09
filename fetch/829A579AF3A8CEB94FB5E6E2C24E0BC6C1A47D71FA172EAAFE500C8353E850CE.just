# maven build
build:
   mvn -DskipTests clean package

# native build
native_build: build
   mvn -DskipTests package native-image:native-image