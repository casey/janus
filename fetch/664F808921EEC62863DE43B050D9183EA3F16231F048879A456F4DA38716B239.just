deploy-fns:
	sls deploy

try-hello:
	npx sls invoke -f hello -d '{"foo":"bar"}'

try-hello-local:
	npx sls invoke local -f hello -d '{"foo":"bar"}'

try-mail:
	npx sls invoke -f mail -p mail/src/fixtures/sns-event-invite.json
