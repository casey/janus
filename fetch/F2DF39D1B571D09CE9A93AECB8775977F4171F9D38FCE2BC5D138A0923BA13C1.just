test:
	go test . -test.v
	NO_COLOR= go test . -test.v
	go test . -test.v | cat
