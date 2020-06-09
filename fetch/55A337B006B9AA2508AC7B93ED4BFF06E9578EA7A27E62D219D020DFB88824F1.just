compile +ARGS='': clean-dist
  yarn tsc -p . {{ARGS}}

clean-dist:
  rm -rf dist/

gen:
  #!/bin/bash
  set -ex
  rm -rf generated
  jk generate -v -i . -o generated dist/index.js

build: compile gen

to-stdout dir: compile
  #!/bin/bash
  set -ex
  jk generate -v -i . --stdout dist/index.js