# build the Justfile plugin
build:
   ./gradlew buildPlugin

# run IDEA with Justfile plugin
run:
  ./gradlew runIdea