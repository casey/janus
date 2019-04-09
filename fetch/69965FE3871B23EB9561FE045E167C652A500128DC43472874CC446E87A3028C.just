# run debug
run +args="": _insidecontainer
	/rustproj/cargo run {{args}}

# Prints the docker-host IP
dockerhostip: _insidecontainer
	@/sbin/ip route | awk '/default/ { print $3 }'

###
### For use OUTSIDE container:
###
# Docker-compose build
devdown: _outsidecontainer
	#!/bin/bash
	set -e
	docker-compose rm

# Docker-compose up akitadb and akita
devup: _outsidecontainer
	#!/bin/bash
	set -e
	docker-compose up

# Interactive bash shell in akita container
devbash: _outsidecontainer
	#!/bin/bash
	set -e
	docker-compose exec rustproj bash

# Docker-compose build
devbuild: _outsidecontainer
	#!/bin/bash
	set -e
	docker-compose build

##
## Misc
##

# Decorator to prevent running outside-container commands within container on accident.
_outsidecontainer:
	#!/bin/bash
	set -e
	if [ -f /.dockerenv ]; then
		echo "That command is only for running outside docker!";
		exit 1
	fi

# Decorator to prevent running inside-container commands outside on accident.
_insidecontainer:
	#!/bin/bash
	set -e
	if [ ! -f /.dockerenv ]; then
		echo "That command is only for running inside docker!";
		exit 1
	fi

# Docker-host user id
curuid:
	@echo $(id -u):$(id -g)

# Current user homedir path
curupath:
	@realpath ~
