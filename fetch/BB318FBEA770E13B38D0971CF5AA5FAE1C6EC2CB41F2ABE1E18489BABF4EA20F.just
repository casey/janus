heapProfile:
  stack run --profile -- +RTS -hy > /dev/null
  hp2ps -e8in -c loop.hp
  okular loop.ps

profile:
  stack run --profile -- +RTS -p > /dev/null

benchmark:
  stack build
  /usr/bin/time -v stack run > /dev/null
