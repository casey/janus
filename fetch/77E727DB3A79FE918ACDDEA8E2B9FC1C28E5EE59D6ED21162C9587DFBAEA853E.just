all: api-cmangos

api-cmangos:
	go build

clean:
	rm -rf api-cmangos


re: clean all

docker-build:
	docker build . -t steakhouse.sysroot.ovh/api-cmangos