default: fmt build run

build:
	go build fetchall.go

run:
	$(eval NOW := $(shell date '+%Y%m%d_%H%M%S'))
	./fetchall -out $(NOW).txt https://golang.org http://gopl.io https://godoc.org
	cat $(NOW).txt

fmt:
	go fmt fetchall.go
