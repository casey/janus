request_response:
    rsocket-cli --metadataFormat text/plain --dataFormat text/plain --request -m "metadata"  -i "data-1" --debug tcp://localhost:42252

fnf:
    rsocket-cli --metadataFormat text/plain --dataFormat text/plain --fnf -m "metadata"  -i "data-1" --debug tcp://localhost:42252

stream:
    rsocket-cli --metadataFormat text --dataFormat text --stream -m "metadata"  -i "data-1" --debug tcp://localhost:42252

rsocket_server:
   rsocket-cli -i "I am a Server" --server --debug tcp://localhost:42252

rsocket_request:
   rsocket-cli --metadataFormat text/plain --dataFormat text/plain --request -i "Hello" --debug tcp://localhost:42252