# run the typescript compiler
build:
	yarn run webpack

run: build
	xdg-open index.html

# clean the destination dir
clean:
	#!/usr/bin/env bash
	if [[ -d dist/ ]]; then
		rm dist/*
	fi
