default:
	@just --choose

all: build

lint: ## Lint the files
	@golint -set_exit_status env_var("PKG_LIST")

test: ## Run unittests
	@go test -short env_var("PKG_LIST")

race: dep ## Run data race detector
	@go test -race -short env_var("PKG_LIST")

msan: dep ## Run memory sanitizer
	@go test -msan -short env_var("PKG_LIST")

coverage: ## Generate global code coverage report
	./tools/coverage.sh;

coverhtml: ## Generate global code coverage report in HTML
	./tools/coverage.sh html;


dep: ## Get the dependencies
	@go mod download

build: dep ## Build the binary file
	@env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/emaild cmd/emaild/main.go

build-win: dep ## Build the binary file
	@env CGO_ENABLED=0 GOARCH=386 GOOS=windows go build -o build/emaild.exe cmd/emaild/main.go

run *ARGS: build
	@build/emaild {{ARGS}}

build-gmail-token:
	@env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o build/gmail-token cmd/gmail-token/main.go

build-gmail-token-win:
	@env CGO_ENABLED=0 GOOS=368 GOARCH=windows go build -o build/gmail-token cmd/gmail-token/main.go

run-gmail-token *ARGS: build-gmail-token
	@build/gmail-token {{ARGS}}

clean: ## Remove previous build
	@rm -f build/*

start-nsq-local:
	docker-compose -f nsq/docker-compose.yml start

logs-nsq-local:
	docker-compose -f nsq/docker-compose.yml logs

stop-nsq-local:
	docker-compose -f nsq/docker-compose.yml stop