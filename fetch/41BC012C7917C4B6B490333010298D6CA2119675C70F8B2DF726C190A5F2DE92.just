help:
  @just -l

buildall:
  cd baseimage && just buildall
  cd components && just buildall
  cd standard && just buildall

pushall:
  cd baseimage && just pushall
  cd components && just pushall
  cd standard && just pushall
