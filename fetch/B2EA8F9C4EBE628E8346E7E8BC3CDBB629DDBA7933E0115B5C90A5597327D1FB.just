#!/usr/bin/env just --justfile
alias r := run
alias i := install
alias q := runq
alias h := help

test:
	go test

build:
	go build

# install and run
install:
	go install
	todogo

run:
	go run .

# run with --quiet
runq:
	todogo -q

# run verbose
runv:
	go run . -- -v

# show program help (invert exit status)
help:
	! todogo -h
