#!/usr/bin/env just --justfile
bin_name := 'goimg'
dev := '0'

alias e := edit
alias r := run
alias b := build
alias i := install
alias h := help

edit:
    $VISUAL main.go

# build release binary
build:
    go build

# build release binary ONLY during dev; otherwise install
install:
    #!/usr/bin/env bash
    if [[ {{dev}} -eq 1 ]]; then
        go build && go run . -test -n -v 2
    else
        go install .
    fi #

# build release binary and run
run:
    go run . -test -n -v 2

help:
    ./{{bin_name}} -h

# run release binary
rb +args='':
    ./{{bin_name}} {{args}}

test:
    go test
