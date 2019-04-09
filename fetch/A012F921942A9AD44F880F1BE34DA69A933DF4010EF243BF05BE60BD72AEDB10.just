
@default:
	just -l

install:
	yarn global add reason-cli@latest-macos
	yarn

build:
	yarn build:dist

watch:
	yarn watch:dist

dev:
	yarn dev
