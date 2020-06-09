compile +ARGS='': clean-dist
  yarn ttsc -p jkcfg {{ARGS}}

clean-dist:
  rm -rf dist/

gen dir:
  #!/bin/bash
  set -ex
  rm -rf {{dir}}/generated
  # needs to be executed from root dir
  cd ..
  jk generate -v -i jkcfg -o jkcfg/{{dir}}/generated jkcfg/dist/{{dir}}/index.js

build dir: compile
  just gen {{dir}}

to-stdout dir: compile
  #!/bin/bash
  set -ex
  cd ..
  jk generate -v -i jkcfg --stdout jkcfg/dist/{{dir}}/index.js