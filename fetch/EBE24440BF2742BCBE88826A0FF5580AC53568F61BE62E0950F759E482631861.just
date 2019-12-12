server:
	./node_modules/hexo/bin/hexo server --debug --verbose

# Build the site once.
build:
	./node_modules/hexo/bin/hexo generate --verbose

# = build
generate:
	just build

# Install development deps.
install:
	npm install
	pip3 install --user yamllint
	git lfs fetch
	git lfs checkout

# Deploy the site.
deploy:
	./node_modules/hexo/bin/hexo generate --verbose

# Resize wishlist images.
resize image:
	./source/img/wishlist/conv.ps1 {{ image }}
