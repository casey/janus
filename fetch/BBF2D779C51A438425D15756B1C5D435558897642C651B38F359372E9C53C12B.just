test:
	npm run test

build:
	elm make ./src/QS.elm

docs:
	elm-make --docs=documentation.json