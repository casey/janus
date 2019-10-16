build:
	go build

lint:
	golangci-lint run --enable-all

tags:
	gotags -R -f "tags" *.go

run:
	go run cmd/main.go
