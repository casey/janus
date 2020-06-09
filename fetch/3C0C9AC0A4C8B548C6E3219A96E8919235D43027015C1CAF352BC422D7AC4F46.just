server:
	./node_modules/hexo/bin/hexo server --debug --verbose

# Build the site once.
build:
	./node_modules/hexo/bin/hexo generate --verbose

# = build
generate:
	just build

# Generate a tar of the node_modules
generate-node-tar:
	#!/usr/bin/env bash
	npm install --ignore-scripts
	archive="node_modules_$(nix-hash --base32 package-lock.json).tar.gz"
	if [[ ! -e "$archive" ]]
	then
		echo "compressing node_modules to $archive"
		tar -cjf "$archive" node_modules
	fi

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
