# Install deps
install:
	esy install

build:
	esy build

# http://localhost:8080/graphql
run:
	esy x Api
	# dune exec main.exe
