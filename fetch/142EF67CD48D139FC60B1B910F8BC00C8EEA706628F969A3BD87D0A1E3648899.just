dev:
  clj -A:nrepl:dev -R:test -C:test

test:
  clj -A:dev:test