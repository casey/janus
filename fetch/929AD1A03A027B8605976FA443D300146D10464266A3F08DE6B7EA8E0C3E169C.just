help:
  @just -l

buildall:
  cd metadata && just build
  cd metadata-jdk8 && just build
  cd metadata-nodejs && just build

pushall:
  cd metadata && just push
  cd metadata-jdk8 && just push
  cd metadata-nodejs && just push
