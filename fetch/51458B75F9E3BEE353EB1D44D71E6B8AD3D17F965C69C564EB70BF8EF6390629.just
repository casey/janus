# Install dependencies
deps:
	type mdbook >/dev/null || cargo +stable install mdbook
	type ghp-import >/dev/null || pip install ghp-import

# Build the book
build:
	mdbook build

# Serve the book at http://localhost:3000/
serve:
	mdbook serve --open

# Update the `gh-pages` branch
gh-pages: build
	ghp-import --cname=book.drone-os.com book
