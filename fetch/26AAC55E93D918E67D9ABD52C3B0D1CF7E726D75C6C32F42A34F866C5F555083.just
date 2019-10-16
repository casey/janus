# https://github.com/casey/just
# just runs the dev server by default
PROJECT_NAME := `basename $PWD`
export NODE_ENV := env_var_or_default('NODE_ENV', 'production')

help:
    @just --list

watch-docker:
    cd .. && docker-compose run builder-haxe just watch

compile: _set-context
    haxe build.hxml

build: _set-context
    webpack

watch: _set-context
    nodemon --legacy-watch --watch src --ext hx --exec 'just compile && just build'

serve: _set-context
    npm run dev

shell:
	cd .. && docker-compose run builder-haxe sh

# Write library versions to the place where jekyll can consume:
# docs/_data/versions.yml
_versions-write-versions-to-jekyll:
	#!/usr/bin/env node
	var Versions = require(process.cwd() + '/test/versions.js');
	var fs = require('fs');
	var p = Versions.getMetapageVersions(true);
	p.then((versions) => { var out = 'versions: ' + JSON.stringify(versions); console.log('./docs/_data/versions.yml:\n' + out + '\n'); fs.writeFileSync('/docs/_data/versions.yml', out + '\n')});

_set-context: # Makes adjustments that depend on if the context is a docker container or the native host.
	@if [ -f /.dockerenv ]; then \
		just _set-context-container; \
	else \
		just _set-context-host; \
	fi

# dev This must be run OUTSIDE a container
_set-context-host:
	@if [ -f /.dockerenv ]; then \
		echo "This must be run outside a docker container (on the host)"; \
		exit 1; \
	fi
	@echo "Context: host"

	@mkdir -p ../../{{PROJECT_NAME}}_node_modules
	@rm -rf node_modules
	@ln -s ../../{{PROJECT_NAME}}_node_modules node_modules

	@mkdir -p ../.haxelib
	@rm -rf .haxelib
	@ln -s ../.haxelib .haxelib

# container libraries are installed in the root so that mounting
# in the project root does not hide the previously installed libs
_set-context-container: ###dev This must be run INSIDE a container
	@if [ ! -f /.dockerenv ]; then \
		echo "This must be run inside a docker container"; \
		exit 1; \
	fi
	@echo "Context: container"
	@rm -rf node_modules
	@ln -s /node_modules node_modules
	@rm -rf .haxelib
	@ln -s /.haxelib .haxelib
