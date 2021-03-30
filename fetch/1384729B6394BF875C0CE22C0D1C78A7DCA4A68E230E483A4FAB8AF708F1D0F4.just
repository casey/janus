default: push-all deploy

deploy:
	./scripts/deploy.sh

push-all: (push "postgresql") (push "pgbench") (push "nsenter") (push "pgio")

push APP: (dockerize APP)
	docker push alexeldeib/{{APP}}:latest

dockerize APP:
	docker build -f images/{{APP}}/Dockerfile images/{{APP}} -t alexeldeib/{{APP}}:latest
