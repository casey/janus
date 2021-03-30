build:
  mvn -DskipTests clean build

dev:
  mvn -DskipTests clean package wildfly:run
