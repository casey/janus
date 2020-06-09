ci:
  stack clean
  stack test --ghc-options=-Werror
  stack bench --no-run-benchmarks --ghc-options=-Werror
