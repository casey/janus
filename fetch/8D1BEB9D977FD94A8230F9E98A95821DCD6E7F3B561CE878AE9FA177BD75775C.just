host = env_var_or_default("AS_HOST", "localhost:8080")
docker_name = env_var_or_default("DOCKER_NAME", "account_service")

run:
	rebar3 run

test:
	rebar3 eunit

get:
	curl -i -H "Accept: application/json" "{{host}}/bankaccounts"

get-default:
	curl -i -H "Accept: application/json" "{{host}}/bankaccounts/default"

docker-build:
	docker build -t {{docker_name}} .

docker-run:
	docker run -it -p 8080:8080 {{docker_name}} run

docker-test:
	docker run -i {{docker_name}} eunit