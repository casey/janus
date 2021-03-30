export DATA_MOUNT_PATH := "/data"

format:
	black ./clutchless

clean-docker:
	sudo docker stop $(sudo docker ps -a -q)
	sudo docker rm $(sudo docker ps -a -q)
	sudo docker volume torrent-data

install:
	poetry build && ls -t dist/*.whl | head -n1 | xargs pip install --upgrade --force-reinstall

image:
	docker build -f docker/clutchless.df -t clutchless .

test: image
	docker run --rm -it clutchless sh -c "python3 -i code/client_setup.py"

compose:
	docker-compose -f ./docker/docker-compose.yml up -d --force-recreate --no-deps --build testbed transmission
	docker-compose -f ./docker/docker-compose.yml run --rm start_dependencies
	docker-compose -f ./docker/docker-compose.yml run --rm testbed sh -c "python3 -i client_setup.py"

integration-build:
	sudo docker-compose -f ./docker/integration/docker-compose.yml build testbed transmission

create-integration-volume:
	sudo docker container create --name temp -v torrent-data:/data busybox
	sudo docker cp ./docker/integration/resources/torrents temp:/data
	sudo docker cp ./docker/integration/resources/data temp:/data
	sudo docker rm temp

integration: integration-build create-integration-volume
	sudo docker-compose -f ./docker/integration/docker-compose.yml up -d transmission
	sudo docker-compose -f ./docker/integration/docker-compose.yml run --rm start_dependencies
	sudo docker-compose -f ./docker/integration/docker-compose.yml run testbed bash