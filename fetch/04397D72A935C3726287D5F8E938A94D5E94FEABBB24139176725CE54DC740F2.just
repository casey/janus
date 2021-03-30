run task:
    @clj -m aoc.{{task}}

test:
    clj -A:test:runner

lint:
    clj -Sdeps '{:deps {clj-kondo/clj-kondo {:mvn/version "RELEASE"}}}' -m clj-kondo.main --lint src

fmt:
    clojure -Sdeps '{:deps {cljfmt/cljfmt {:mvn/version "RELEASE"}}}' -m cljfmt.main fix src/ test/ deps.edn

# Run headless nREPL server, needed by fireplace.vim
nrepl:
    clj -R:nREPL -m nrepl.cmdline
