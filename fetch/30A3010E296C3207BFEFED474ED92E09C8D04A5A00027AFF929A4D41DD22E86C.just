
# initialize the repository
init:
	mkdir -p ./data/builder/data || true
	mkdir -p ./data/builder/etc || true
	mkdir -p ./data/mangosd/data || true
	mkdir -p ./data/mangosd/etc || true
	mkdir -p ./data/realmd/data || true
	mkdir -p ./data/realmd/etc || true
	mkdir -p ./data/mysql || true

# Create the docker container used to build realmd and mangosd and used to initialize the db
create-builder:
    docker build -f ./services/builder/Dockerfile -t steakhouse.sysroot.ovh/builder .

# Build the current version of realmd and mangosd
build-servers:
	docker run -v ` realpath ./data/builder/etc`:/runtime/etc -v ` realpath ./data/builder/data`:/runtime/data steakhouse.sysroot.ovh/builder build.sh

# Build the dev version of realmd and mangosd
build-dev-servers:
	#! /usr/bin/bash
	if [ ! -d "./data/builder/data/mangos" ]; then echo "First clone the cmangos-classic repository in './data/builder/data/mangos'"; exit 1 ; fi
	docker run -v ` realpath ./data/builder/etc`:/runtime/etc -v ` realpath ./data/builder/data`:/runtime/data steakhouse.sysroot.ovh/builder dev-build.sh

# Extracts the maps from the WOW client directory and put them in the mounted volume of the game server
extract-maps path:
	cp ./data/builder/data/run/bin/tools/* {{ path }}
	files=`ls ./data/builder/data/run/bin/tools/` && cd {{ path }} && chmod 755 ./ExtractResources.sh && ./ExtractResources.sh ; rm $files
	mv {{ path }}/maps/ ./data/mangosd/data/ || true
	mv {{ path }}/vmaps/ ./data/mangosd/data/ || true
	mv {{ path }}/mmaps/ ./data/mangosd/data/ || true
	mv {{ path }}/dbc/ ./data/mangosd/data/ || true

# Initialize the db with the builder
init-db realmhost="127.0.0.1":
	docker-compose run -e OVERLOADED_REALM_HOST={{ realmhost }} initdb
	docker-compose up -d mangosd
	sleep 2
	just exec account delete ADMINISTRATOR
	just exec account delete GAMEMASTER
	just exec account delete MODERATOR
	just exec account delete PLAYER
	docker-compose down

# reset the db
reset-db:
	docker-compose down
	rm -rf ./data/mysql/*

# Start the auth and game server
run +cmd="":
	docker-compose up {{ cmd }} mysql realmd mangosd api web

# start a terminal on the game server
terminal:
	docker-compose exec mangosd ./terminal.sh

# execute a new command on the game server
exec +cmd:
	docker-compose exec mangosd ./exec.sh {{ cmd }}