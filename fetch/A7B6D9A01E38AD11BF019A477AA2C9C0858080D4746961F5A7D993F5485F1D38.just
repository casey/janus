build:
	go build fetch.go
	go build server.go

run:
	sudo ./server &
	
hello:
	./fetch 'http://localhost/hello'
