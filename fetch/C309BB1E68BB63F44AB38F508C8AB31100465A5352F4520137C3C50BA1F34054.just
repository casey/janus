# just docs: https://github.com/casey/just

_help:
    @just --list

# Serves development app at http://localhost:1234
serve:
    npm start

# Builds a production build
build:
    @mkdir -p dist
    @rm dist/*
    npm run build
    sed -i -e 's#/src#./src#g' dist/index.html
    find dist/*.js -type f -exec sed -i 's#/src#./src#g' {} \;

# Publish to github
publish: build
    npx gh-pages -d dist
