start:
	gutenberg serve

build:
	gutenberg build
	mv public ../client/dist-web
