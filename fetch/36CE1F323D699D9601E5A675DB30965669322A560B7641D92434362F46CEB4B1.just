#!/usr/bin/env just --justfile

set shell := ["sh", "-c"]

output := "a.out"
s := `echo sudo`

export CDPATH := ""

default:
	@echo "You are using {{os()}} in {{invocation_directory()}}"

build:
	-false
	clang -Werror -Wpedantic main.c util.c

run:
	-DEBUG= {{s}} --preserve-env=DEBUG ./{{output}}

_private:

do: build run
