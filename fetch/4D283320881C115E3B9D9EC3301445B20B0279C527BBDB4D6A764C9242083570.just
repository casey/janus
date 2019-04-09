serve:
	zola serve

build:
	zola build

deploy: build
	netlify deploy --dir=public --prod