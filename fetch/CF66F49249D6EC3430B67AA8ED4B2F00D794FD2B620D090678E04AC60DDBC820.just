# install rsocket-cli
setup:
  brew install yschimke/tap/rsocket-cli

# request testing
request_response:
  rsocket-cli --request -i "I am a Client" --debug tcp://localhost:42252

# stream testing
request_stream:
  rsocket-cli --stream -i "Word Up" tcp://localhost:42252