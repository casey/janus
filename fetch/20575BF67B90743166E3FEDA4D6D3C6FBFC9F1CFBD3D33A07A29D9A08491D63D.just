build:
	dune build ./bin/main.exe

# http://localhost:8080/graphql
start:
	dune exec ./bin/main.exe
