run:
	go run .

# glow: https://github.com/charmbracelet/glow
view:
	glow community.md

generate:
	go run . convert

copy:
	#!/bin/sh -u
	cp -r assets docs
	cp community.html docs/index.html
