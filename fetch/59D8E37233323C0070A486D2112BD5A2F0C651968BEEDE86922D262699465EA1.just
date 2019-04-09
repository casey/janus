# run Single source java file
script:
   java --source 11 src/main/java/org/mvnsearch/App.java

# display update dependencies
update:
   mvn versions:display-dependency-updates

# build the application
build:
   mvn -DskipTest clean package

# run main application
run:
  java -classpath target/java11_in_action-1.0.0-SNAPSHOT.jar org.mvnsearch.App

# run main app with debug mode
debug:
  java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -classpath target/java11_in_action-1.0.0-SNAPSHOT.jar org.mvnsearch.App

# test the app
test:
   mvn clean test