# run test suite
test:
	bin/kaocha

# start a repl
repl:
	clj -A:test:dev

# migrate the database
migrate:
	clojure --m rgm.cli migrate-db

# rollback the database
rollback:
	clojure --m rgm.cli rollback-db

# rebuild clj-kondo cache
lint-cache:
	clj-kondo --lint $(clojure -Spath)

# hunt down unused vars
carve:
	clojure -m carve.main --opts '{:paths ["src/clj" "test/clj"]}'

# vim: ft=make
