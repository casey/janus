version := "v2"

environment_name := "capucine"
start := "2020-01-17T13:00"
end := "2020-01-17T14:00"
source := "cuwb"

system-info:
    @echo "system info: {{ os() }} ({{ os_family() }}) on {{arch()}}".

_build-docker-service:
    @docker build -t wildflowerschools/honeycomb-geom-processor:{{version}} -f Dockerfile .

_build-docker-prepare:
    @docker build -t wildflowerschools/honeycomb-geom-processor:prepare-{{version}} -f Prepare.Dockerfile .

build-docker: _build-docker-service _build-docker-prepare

docker-push: build-docker
    @docker push wildflowerschools/honeycomb-geom-processor:{{version}}
    @docker push wildflowerschools/honeycomb-geom-processor:prepare-{{version}}

tag-release:
    git tag -a {{version}} -m ""

push-release: tag-release
    git push origin `git describe --abbrev=0`

prepare-geoms:
    @python -m honeycomb_tools prepare-geoms-for-environment-for-time-range-for-source --environment_name {{environment_name}} --start {{start}} --end {{end}} --source {{source}}
