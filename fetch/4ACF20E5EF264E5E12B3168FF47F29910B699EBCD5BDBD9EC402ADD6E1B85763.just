serve:
	~/opt/go_appengine/goapp serve

open:
	open http://localhost:8080

push:
	python2.7 ~/opt/go_appengine/appcfg.py update .

format:
	gofmt -w *.go

lint:
	go vet
	golint
