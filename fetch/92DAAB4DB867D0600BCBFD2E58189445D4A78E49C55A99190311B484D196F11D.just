# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
# description: build or run or lint
# https://github.com/casey/just

prog := "ceres"
src  := "src/" + prog + ".cr"

# build and run
run: build
  ./{{prog}}

# build
build:
  #!/usr/bin/env bash
  if [[ -f makefile ]]; then
    make
  else
    time crystal build {{src}}
  fi
  if [ $? -eq 0 ]; then
    if [[ -f {{prog}}.dwarf ]]; then
      echo rm {{prog}}.dwarf
    fi
  else
    exit
  fi

lint:
  ameba

log:
  most ~/tmp/{{prog}}log.txt

install:
  time crystal build {{src}} --release
  cp {{prog}} ~/bin
