elm-test:
  elm-test

elm-coverage:
  elm-coverage

test: elm-test
  elm-verify-examples --run-tests

coverage: elm-coverage
  elm-verify-examples --run-tests
