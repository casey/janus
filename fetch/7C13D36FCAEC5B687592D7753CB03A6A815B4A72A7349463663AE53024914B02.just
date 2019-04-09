help:
  @just -l

buildall:
  cd alpine && just buildall
  cd ubuntu && just buildall

pushall:
  cd alpine && just pushall
  cd ubuntu && just pushall
