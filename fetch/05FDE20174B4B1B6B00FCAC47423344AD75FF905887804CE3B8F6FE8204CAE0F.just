add-to-opam:
	opam pin add proj . -n

build:
	dune build ./bin/main.exe

# dune build _build/default/bin/main.exe

run:
	dune exec ./bin/main.exe