# rsocket request/response testing
rsocket_request_response:
   rsocket-cli --request -i "I am a Client" tcp://localhost:7000

# send messages to kafka from console input
send_kafka_messages:
   docker-compose exec kafka /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic testTopic
