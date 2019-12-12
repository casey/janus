
version := "v0-local"

environment_name := "capucine"
output_path := "public/videos"
output_name := ""
start := "13:00"
end := "22:00"

system-info:
    @echo "system info: {{ os() }} ({{ os_family() }}) on {{arch()}}".

_build-docker-service:
    @docker build -t wildflowerschools/honeycomb-video-streamer:{{version}} -f Dockerfile .

_build-docker-prepare:
    @docker build -t wildflowerschools/honeycomb-video-streamer:prepare-{{version}} -f Prepare.Dockerfile .

build-docker: _build-docker-service _build-docker-prepare

docker-push: build-docker
    @docker push wildflowerschools/honeycomb-video-streamer:{{version}}
    @docker push wildflowerschools/honeycomb-video-streamer:prepare-{{version}}


prepare-videos:
    @python -m honeycomb_tools prepare-videos-for-environment-for-time-range  --environment_name {{environment_name}} --output_path {{output_path}} --output_name {{output_name}} --start {{start}} --end {{end}}
