export PE_CONNECTION_URL := "http://localhost:8080"
# build the project
build:
  ./mvnw -DskipTests clean package

# release
release:
  ./mvnw -DskipTests clean package spring-boot:repackage

# clean project
clean:
  ./mvnw clean

# pulsar-express for Pulsar web admin
ui:
   npx pulsar-express

# update artifactId
artifact artifactId:
  sed -i .bak 's|<artifactId>spring-boot-java-template</artifactId>|<artifactId>{{artifactId}}</artifactId>|' pom.xml
  rm pom.xml.bak