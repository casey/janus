# This file is part of "crypt" module.
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-crypt
# ------------------------------------------------------------------------------

# Lists recipes
default:
  @just --list

# Runs the spec
spec FILES='' FLAGS='--progress':
  crystal spec {{FLAGS}} {{FILES}}
  @echo spec done!

alias test := spec

# Start watching files in APP_ENV=local
local *CMD:
 #!/bin/bash
  APP_ENV=${APP_ENV:=local}
  LOG=${LOG:=debug}
  echo "Start watching files in APP_ENV=${APP_ENV}"
  echo "..."
  watchexec -w src -w spec --exts cr,ecr -r -- crystal spec --error-trace -p -- '{{CMD}}'

alias develop := local

# Crystal tool format ./src/ ./spec
format:
  crystal tool format ./src/ ./spec
  @# format done!

alias f := format

# Check the code
@lint:
    echo Checking for FIXME/TODO...
    ! grep --color -Enr 'FIXME|TODO' src/*.cr
    ! grep --color -Enr 'FIXME|TODO' spec/*.cr
    echo Checking for 'spec focus: true'...
    ! grep --color -Enr 'focus: true do' spec/*.cr
    echo Checking for long lines...
    ! grep --color -Enr '.{101}' src/**.cr
    ! grep --color -Enr '.{101}' spec/**.cr
    crystal tool format --check ./src ./spec
    echo Checking with Ameba linter
    ./bin/ameba
    @# check done!
