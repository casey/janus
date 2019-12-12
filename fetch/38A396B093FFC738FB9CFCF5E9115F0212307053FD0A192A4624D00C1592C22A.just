# https://github.com/casey/just

NODE_ENV := 'development'
PORT := env_var_or_default("PORT", "4010")

# If we're not running in a docker container
_first:
	just --list

help:
    @just --list

# Run the stack. Actually easier to just serve but whatever
run:
    docker-compose up --remove-orphans

# serve and build on [src] change
serve:
    npm run dev

# build artifact to {{FINAL_BUILD_TARGET}}
build:
	npm run build
	cp src/CNAME build/
	sed -i -e 's#href="/#href="#g' build/index.html
	sed -i -e 's#src="/#src="#g' build/index.html
	sed -i -e 's#/assets#assets#g' build/sw.js
	sed -i -e 's#/assets#assets#g' build/manifest.json

# [src] change -> build artifact to {{FINAL_BUILD_TARGET}}
watch:
    nodemon --watch src --exec just build

# deploy to gh-pages branch
publish: build
	npm run deploy

# Upgrade metapage/metaframe packages to the latest versions
upgrade:
	npm i --save metapage@latest
	npm i --save metaframe@latest

# Set the metapage npm package location to a local directory (requires $METAPAGE_BUILD_DIR)
dev-set-local-metapage-lib:
	sed -i "s#\"metapage\":.*#\"metapage\": \"file:$METAPAGE_BUILD_DIR\",#g" package.json

dev-set-local-metapage-lib-undo:
	sed -i "s#\"metapage\":.*#\"metapage\": \"`npm show metapage version`\",#g" package.json

# CLI shell in the docker container
docker-cli:
	just _get-in-docker

_get-in-docker:
	docker-compose run --rm -p '4010:{{PORT}}' metapage-app /bin/sh
