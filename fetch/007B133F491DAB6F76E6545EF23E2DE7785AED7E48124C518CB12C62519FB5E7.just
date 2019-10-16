alias b := build
alias r := run
alias i := install

test:
	go test

build:
	go build

install:
	go install

run:
	./optimg

# run with debug verbosity
runv:
	./optimg -debug

# display help message
help:
	! ./optimg -h
