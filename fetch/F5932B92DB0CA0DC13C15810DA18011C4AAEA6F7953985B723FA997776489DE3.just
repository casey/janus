serve:
	~/opt/go_appengine/goapp serve .

deploy:
	python2.7 ~/opt/go_appengine/appcfg.py update .

open:
	open http://localhost:8080/

format:
	gofmt -w *.go

lint:
	go vet
	@golint | sed "/don't use underscores/d"

test:
	./test http://localhost:8080

test-deployed:
	./test http://rodarmor-stash.appspot.com
