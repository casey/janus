dev:
  clj -A:nrepl:dev -R:test -C:test

test *ARGS:
  clj -A:dev:test {{ARGS}}