build:
  mvn -DskipTests clean package

deploy-dry-run:
  mvn -pl rsocket-loadbalance-spring-boot-starter -P release -DskipTests clean package

deploy:
  mvn -pl rsocket-loadbalance-spring-boot-starter -P release -DskipTests clean package deploy

start-servers: build
  java -jar server-app/target/server-app-1.0.0-SNAPSHOT.jar --spring.rsocket.server.port=6565 &
  java -jar server-app/target/server-app-1.0.0-SNAPSHOT.jar --spring.rsocket.server.port=6566 &
  java -jar server-app/target/server-app-1.0.0-SNAPSHOT.jar --spring.rsocket.server.port=6567 &
  
stop-servers:
  kill -9 $(lsof -t -i:6565) &
  kill -9 $(lsof -t -i:6566) &
  kill -9 $(lsof -t -i:6567) &

consul-server:
  consul agent -dev