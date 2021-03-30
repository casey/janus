#!/usr/bin/env just --justfile

test_contains:
	clang -c ../util.c
	clang -c test_contains.c
	clang -o ./test util.o test_contains.o
	./test


test: test_contains
