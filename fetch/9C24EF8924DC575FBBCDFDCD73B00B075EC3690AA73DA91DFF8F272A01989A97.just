all: build format lint

build: render-ci-pipeline

render-ci-pipeline:
    ./scripts/render-ci-pipeline.sh

format: format-dhall prettier format-shfmt

lint: lint-dhall shellcheck

prettier:
    yarn run prettier

format-dhall:
    ./scripts/dhall-format.sh

lint-dhall:
    ./scripts/dhall-lint.sh

shellcheck:
    ./scripts/shellcheck.sh

format-shfmt:
    shfmt -w .

install:
    just install-asdf
    just install-yarn

install-yarn:
    yarn

install-asdf:
    asdf install
