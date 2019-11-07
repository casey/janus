all: setup check test run

setup:
  yarn

check:
  tsc --project . --noEmit

run:
  ts-node src/index.ts

test:
  jest

watch:
  jest --watch

watch-check:
  tsc --project . --noEmit --watch
