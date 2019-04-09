start:
	cargo run

try:
	curl -X POST \
		--data '{ "query": "{ admin { investors { name } } }" }' \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer $SYSTEM_JWT" \
		http://127.0.0.1:4010/app/graphql?id=data

try-prod:
	curl -X POST \
		--data '{ "query": "{ admin { investors { name } } }" }' \
		--header "Content-Type: application/json" \
		--header "Authorization: Bearer $SYSTEM_JWT_PROD" \
		http://51.15.65.131/app/graphql?id=data

dp-setup:
	DATABASE_URL=$DATABASE_URL_LOCAL diesel setup

db-gen name:
	diesel migration generate {{name}}

db-up:
	DATABASE_URL=$DATABASE_URL_LOCAL diesel migration run
	DATABASE_URL=$DATABASE_URL_TEST diesel migration run

db-down:
	DATABASE_URL=$DATABASE_URL_LOCAL diesel migration revert
	DATABASE_URL=$DATABASE_URL_TEST diesel migration revert

dp-setup-test:
	DATABASE_URL=$DATABASE_URL_TEST diesel setup

schema:
	DATABASE_URL=$DATABASE_URL_LOCAL diesel print-schema > src/models/schema.rs

test:
	APP_ENV=test cargo test

# Build the server infrastructe in Scaleway
# provision:
# 	terraform apply

# Build the Rust application binary
build:
	docker run \
		--rm \
		-it \
		-v $PWD:/volume/ \
		-v cargo-cache:/root/.cargo \
		clux/muslrust:nightly \
		cargo build --release

# Copy the binary into /dist/bin
copy-bin:
	mkdir -p ./dist/bin/
	rm -rf ./dist/bin/*
	cp target/x86_64-unknown-linux-musl/release/api ./dist/bin
	mv ./dist/bin/api ./dist/bin/api.exe

# This makes the binary smaller
# But it removes valuable stack tracing information
strip:
	docker run --rm -it \
		-v $PWD:/volume/ \
		clux/muslrust:nightly \
		strip ./dist/bin/api.exe

compress:
	cd ./dist/bin/ && tar -zcvf api.tar.gz api.exe

# Run before deploy when binary has changed
prepare-release: build copy-bin compress

# run ssh-add first
deploy: prepare-release
	deployr run -verbose \
		--set "API_SECRET=$API_SECRET_PROD" \
		--set "CLIENT_HOST=$CLIENT_HOST_PROD" \
		--set "DATABASE_URL=$DATABASE_URL_PROD" \
		--set "SYSTEM_JWT=$SYSTEM_JWT_PROD" \
		./deployr.recipe

docker-run-local:
	docker run \
		--rm \
		--name save-up-api \
		--env RUST_BACKTRACE=1 \
		--env-file ./env.prod \
		--expose=4010 \
		-p 4020:4010 \
		$API_IMAGE_TAG
