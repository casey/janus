format:
	black ./clutchless

clean-docker:
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	docker volume rm docker_torrent-data

install:
	poetry build && ls -t dist/*.whl | head -n1 | xargs pip install --upgrade --force-reinstall

image:
	docker build -f docker/clutchless.df -t clutchless .

shell: image
	docker run --rm -it clutchless

test: image
	docker run --rm -it clutchless sh -c "python3 -i code/client_setup.py"

compose:
	docker-compose -f ./docker/docker-compose.yml up -d --force-recreate --no-deps --build testbed transmission
	docker-compose -f ./docker/docker-compose.yml run --rm start_dependencies
	docker-compose -f ./docker/docker-compose.yml run --rm testbed sh -c "python3 -i client_setup.py"

testbed-shell:
	docker-compose -f ./docker/docker-compose.yml build testbed transmission
	docker-compose -f ./docker/docker-compose.yml up -d transmission
	docker-compose -f ./docker/docker-compose.yml run --rm start_dependencies
	docker cp ./docker/resources/torrents docker_transmission_1:/app/resources/torrents
	docker cp ./docker/resources/data docker_transmission_1:/app/resources/data
	docker-compose -f ./docker/docker-compose.yml run testbed bash
