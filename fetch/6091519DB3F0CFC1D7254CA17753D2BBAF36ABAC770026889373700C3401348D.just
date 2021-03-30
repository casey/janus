

deps:
    lein deps

dev:
    cp resources/public/dev-index.html resources/public/index.html

prod:
    cp resources/public/prod-index.html resources/public/index.html

release:
    just prod
    lein release

deploy:
    just release
    firebase deploy