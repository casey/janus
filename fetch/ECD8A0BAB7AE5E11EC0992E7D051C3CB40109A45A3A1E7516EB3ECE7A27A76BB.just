help:
  @just -l

buildall:
  cd cerebro && just build
  cd elastichd && just build
  cd elasticsearch-head && just build
  cd elasticsearch-sql && just build

pushall:
  cd cerebro && just push
  cd elastichd && just push
  cd elasticsearch-head && just push
  cd elasticsearch-sql && just push
