# Local Variables:
# mode: makefile
# End:
# vim: set ft=make :
# description: build or run or lint
# https://github.com/casey/just

# build and run
run: build
  ./fff

# build
build:
  #!/usr/bin/env bash
  if [[ -f makefile ]]; then
    make
  else
    time crystal build src/fff.cr
  fi

lint:
  ameba

log:
  most ~/tmp/fff.log

install:
  crystal build src/fff.cr --release
  cp fff ~/bin/fffcr
