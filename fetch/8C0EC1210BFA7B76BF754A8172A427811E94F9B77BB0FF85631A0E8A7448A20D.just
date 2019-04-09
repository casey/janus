default: fmt build run

build:
	go build fetchall.go

fmt:
	go fmt fetchall.go

run:
	$(eval NOW := $(shell date '+%Y%m%d_%H%M%S'))
	./fetchall -out data/out/$(NOW)_top-50.txt -in data/in/top-50.txt
	cat data/out/$(NOW)_top-50.txt

getsites: download extract setup

download:
	wget 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'
	mv top-1m.csv.zip data/in/

extract:
	unzip data/in/top-1m.csv.zip -d data/in/

setup:
	cut -d, -f2 data/in/top-1m.csv | sed 's/^/http:\/\//' > data/in/top-1m.txt
	head -50 data/in/top-1m.txt > data/in/top-50.txt



