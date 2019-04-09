help:
  @just -l

buildall:
  cd elasticsearch && just build
  cd kibana && just build
  cd logstash && just build

pushall:
  cd elasticsearch && just push
  cd kibana && just push
  cd logstash && just push
