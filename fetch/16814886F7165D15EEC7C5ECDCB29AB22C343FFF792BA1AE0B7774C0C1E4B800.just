default: image push

image:
	docker build . -t alexeldeib/demo:latest

push:
	docker push alexeldeib/demo:latest
