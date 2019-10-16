deploy-fns:
	npx sls deploy

try-hello:
	npx sls invoke -f hello -d '{"foo":"bar"}'

try-hello-local:
	npx sls invoke local -f hello -d '{"foo":"bar"}'

try-mail:
	env SLS_DEBUG=* npx sls invoke -f mail -p mail/src/fixtures/sns-event-invite.json

start:
	cargo run --bin api

build:
	cargo build

build-test:
	cargo build --tests 2>&1 | awk '/error.*:/{n++};n < 2'

# build:
# 	docker run \
# 		--rm \
# 		-it \
# 		-v $PWD:/volume/ \
# 		-v cargo-cache:/root/.cargo \
# 		clux/muslrust:nightly \
# 		cargo build --release
