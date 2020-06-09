build:
  docker run --rm -v $HOME/projects/compiler/9cc:/9cc -w /9cc compilerbook make
test:
  docker run --rm -v $HOME/projects/compiler/9cc:/9cc -w /9cc compilerbook make test
