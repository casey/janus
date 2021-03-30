build: build-core build-py build-dcp

build-core:
	docker build -t m2/core -f core.Dockerfile .

build-py: build-core
	docker build -t m2/py -f py.Dockerfile .

build-dcp: build-py
	docker-compose build

run *args: build
	docker-compose up {{args}}

run-bg: build
	docker-compose up -d
