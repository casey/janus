# Just is awesome: https://github.com/casey/just

# Build everything
build : build-haskell build-c

# Build C code
build-c :
  cd cmake-build-vsc && cmake --build .

# Build Haskell code
build-haskell :
  stack build

# Test everything
test : test-unit test-suite

# Run compiler & runtime unit tests
test-unit : test-haskell test-c

# Test C code
test-c : build-c
  cd cmake-build-vsc && ctest -j 4 --output-on-failure

# Test Haskell code
test-haskell : build-haskell
  stack test

# Run Intentio Reference Test Suite
test-suite : build
  stack exec test-runner -- --no-cleanup --root ./test --compiler ./bin/test-intentioc.sh

# Watch for changes in Haskell code
watch-haskell STACK_CMD='test' :
  stack {{ STACK_CMD }} --file-watch

# Watch for changes in C code
watch-c CMD='just test-c' :
  #!/usr/bin/env bash
  while :; do
    rg --files | entr -d bash -c '{{ CMD }}'
  done

# Watch for changes anywhere and run test suite
watch-suite CMD='just test-suite' :
  #!/usr/bin/env bash
  while :; do
    rg --files | entr -d bash -c '{{ CMD }}'
  done

# Run all linters
lint : hlint

# Run HLint over Haskell codebase
hlint :
	hlint -gj --cross

# Format both Haskell and C code
fmt : brittany clang-format

# Format Haskell code
brittany :
	rg --files | rg '\.hs$' | xargs brittany --write-mode inplace --output-on-errors

# Format C code
clang-format :
  rg --files | rg '\.(h|hpp|c|cpp)$' | xargs clang-format -i

# (Re)create CMake development directory
init-cmake :
  rm -rf cmake-build-vsc
  mkdir -p cmake-build-vsc
  cd cmake-build-vsc && cmake -DCMAKE_BUILD_TYPE=Debug ..

# Clean all build artifacts
clean : clean-stack clean-cmake clean-intentio

# Clean Haskell Stack work directory
clean-stack :
  rm -rf .stack-work

# Clean development CMake work directory
clean-cmake :
  rm -rf cmake-build-vsc

# Clean Intentio work directory
clean-intentio :
  rm -rf .intentio-work
