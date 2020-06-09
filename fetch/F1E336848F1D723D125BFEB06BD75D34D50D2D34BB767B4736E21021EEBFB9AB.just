app_version := "0.1.0"
app_name := "jitsi-videobridge"
docker_user_id := "dmi7ry"
docker_image_name := docker_user_id + "/" + app_name + ":" + app_version
docker_image_latest := docker_user_id + "/" + app_name + ":latest"
build_date := `date -u +"%Y-%m-%dT%H:%M:%SZ"`

alias build := build-c
alias rmi := images-clean-unused
alias rmis := remove-images
alias rmf := containers-clean-all
alias v := version

_build build_args="--no-cache":
  docker build {{build_args}} -t {{docker_image_name}} \
  --build-arg VERSION={{app_version}} \
  --build-arg BUILD_DATE={{build_date}} \
  -f Dockerfile .
# docker build with cache with squash flag
build-c: (_build "")
# docker build --no-cache
build-nc: (_build "--no-cache")
# docker build --no-cache --squash
build-nc-sq: (_build "--no-cache --squash")

build-exporter:
  docker build -t "dmi7ry/jitsi-videobridge-exporter:0.0.1" -f Dockerfile-exporter .
run-exporter:
  docker run -d -p 7979:7979 --rm --name jitsi-videobridge-exporter "dmi7ry/jitsi-videobridge-exporter:0.0.1"


# sh into container
bash:
  docker run -it --rm --name {{app_name}} {{docker_image_name}} bash
# start container with docker-compose
compose:
  docker-compose -f docker-compose.yml up -d
# stop container with docker-compose
compose-down:
  docker-compose -f docker-compose.yml down
# docker logs
logs:
  docker logs {{app_name}}
inspect:
  docker inspect {{app_name}}

_run ARGS="":
  docker run {{ARGS}} --rm --name {{app_name}} {{docker_image_name}}
run: (_run "")
run-d: (_run "-d")

# push image to dockerhub
push IMAGE=(docker_image_name):
  docker push {{IMAGE}}
# push latest image to dockerhub
push-latest:
  docker tag {{docker_image_name}} {{docker_image_latest}}
  docker push "{{docker_user_id}}/{{app_name}}:latest"
# build --no-cache then push
publish: build-nc push

# get full scan image info with DIVE tool
dive:
  dive {{docker_image_name}}


# clean everything after builds
clean: containers-clean-all images-clean-unused remove-images
  docker ps -a
  docker images
# clean unused images
images-clean-unused:
  docker images | grep none | awk '{ print $3 }' | xargs -I{} docker rmi {}
# remove all containers
containers-clean-all:
  docker ps -aq | xargs -I{} docker rm -f {}
# remove specific image
remove-image image=(docker_image_name):
  docker rmi {{image}}
# remove all linked images
remove-images:
  @docker images | grep {{app_name}} | awk '{ print $3 }' | xargs -I{} docker rmi {}

# print current image version
version:
  @echo {{docker_image_name}}