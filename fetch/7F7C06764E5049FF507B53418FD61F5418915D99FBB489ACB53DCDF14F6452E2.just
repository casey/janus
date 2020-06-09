app_version := `curl -H "Authorization: bearer $GITHUB_API_KEY" -sXGET https://api.github.com/repos/MinterTeam/minter-go-node/tags | jq -r '.[].name' | head -1 | sed 's/v//'`
app_name    := "minter-node"
docker_id   := "dmi7ry"
docker_image_name := docker_id + "/" + app_name + ":" + app_version
build_date := `date -u +"%Y-%m-%dT%H:%M:%SZ"`

all: build-c

alias build := build-c
alias v := version

_build ARGS="" BUILD_VERSION=app_version:
	docker build {{ARGS}} -t {{docker_id}}/{{app_name}}:{{BUILD_VERSION}} --build-arg VERSION={{BUILD_VERSION}} --build-arg BUILD_DATE={{build_date}} .
build-c: (_build)
build-nc: (_build "--no-cache")
build-nc-sq: (_build "--no-cache --squash")

release version +COMMENT:
  git add -A
  git commit -m "{{COMMENT}}"
  git tag -a {{version}} -m "{{version}}"
  git push origin
  git push origin {{version}}

run CMD="":
	docker run -it --rm --name {{app_name}} {{docker_image_name}} {{CMD}}

dive:
  dive {{docker_image_name}}

bash:
	docker run -it --rm --name {{app_name}} {{docker_image_name}} bash

publish: build-c push

push BUILD_VERSION=app_version:
	docker push {{docker_id}}/{{app_name}}:{{BUILD_VERSION}}

version:
  @echo {{app_version}}

clean: containers-clean-all images-clean-unused remove-images
	docker ps -a
	docker images
images-clean-unused:
	docker images | grep none | awk '{ print $3 }' | xargs -I{} docker rmi {}
containers-clean-all:
	docker ps -aq | xargs -I{} docker rm -f {}
remove-image image=(docker_image_name):
	docker rmi {{image}}
remove-images:
	@docker images | grep {{app_name}} | awk '{ print $3 }' | xargs -I{} docker rmi {}
