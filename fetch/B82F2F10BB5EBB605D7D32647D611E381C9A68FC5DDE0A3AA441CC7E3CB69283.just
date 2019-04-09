LAB = cd .lab

default: build

ci:
	@${LAB} && mix local.rebar --force
	@${LAB} && mix local.hex --force

deps:
	@${LAB} && mix deps.get

build:
	@${LAB} && mix

run:
	@${LAB} && iex -S mix run --no-halt

test:
	@${LAB} && mix test
