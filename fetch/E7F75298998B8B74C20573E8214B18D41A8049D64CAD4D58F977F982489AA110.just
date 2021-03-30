server:
   rsocket-cli -i "pong" --server --debug tcp://localhost:42252

request:
    rsocket-cli --request -i "ping" --debug tcp://localhost:42252

server-stream:
   rsocket-cli --debug -i=@/Users/linux_china/data/words --server tcp://localhost:42252

stream:
   rsocket-cli --stream -i "Word Up" --debug tcp://localhost:42252

qodana:
   docker run -it -v ~/github/rsocket/rsocket-php/:/data/project/  -p 8080:8080 jetbrains/qodana --show-report
