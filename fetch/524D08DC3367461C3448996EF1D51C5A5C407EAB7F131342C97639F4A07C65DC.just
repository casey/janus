# vim: set ft=make :

help:
	@echo "just is a convenient command runner. Try just -l"

env = 'dev'

# Run a command for all functions
run-all command +ARGS='':
	#!/bin/bash
	set -euo pipefail
	for d in function/* ; do
	  pushd "$d"
	  just env={{env}} {{command}} {{ARGS}}
	  popd 1>/dev/null
	done

# Typecheck and run all tests
new-function function_name:
	#!/bin/bash
	set -euo pipefail
	mkdir function/{{function_name}}
	pushd function/{{function_name}} 1>/dev/null
	cp ../../template/handler.py .
	ln -s ../../library library
	ln -s ../../template/mypy.ini mypy.ini
	ln -s ../../template/justfile justfile
	ln -s ../../template/.gitignore .gitignore
	ln -s ../../vendor/requests vendor
	touch README.md

test-all: mypy-all flake8-all

flake8-all:
	@flake8 library function/*/handler.py

mypy-all:
	#!/bin/bash
	set -euo pipefail
	mypy library
	# complains of duplicate modules
	for f in function/*/handler.py ; do
	  mypy "$f"
	done
