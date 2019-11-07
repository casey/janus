#!/usr/bin/env just --justfile

GIT_TAG := `git describe --abbrev=0 --tags || true`

test: build check
	cargo test

build:
	cargo build

check:
	cargo check

run: test
	cargo run

test-release: build-release check-release
	cargo test --release --verbose

build-release:
	cargo build --release --verbose

check-release:
	cargo check --release --verbose

run-release: test-release
	cargo run --release

clean:
	cargo clean

install-dev-deps:
	# rustup install nightly
	rustup override set nightly
	# rustup update nightly
	cargo install clippy
	cargo install rustfmt

lint:
	cargo clippy
	echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/*.rs
	echo Checking for long lines...
	! grep --color -En '.{101}' src/*.rs

format:
	cargo fmt

# build a statically linked linux binary
static-binary: test-release
	./ci/static_binary_builder.sh

# preps for releasing a new version
release-preps TAG:
	git checkout -b release-{{TAG}}

# release task(to be run locally)
release TAG:
	@echo "Bumping version numbers to {{TAG}}, updating Cargo.lock"
	./scripts/bump_cargo_version.sh {{TAG}}
	./scripts/bump_release_dockerfile_version.sh {{TAG}}
	just check
	@echo "Git operations"
	git commit -a -m "Bump version numbers to {{TAG}}, update Cargo.lock"
	git checkout master
	git merge --no-ff --signoff --commit release-{{TAG}}
	git tag -s -F changelog/{{TAG}}.txt {{TAG}}
	git push --follow-tags origin master
	git checkout develop
	git merge --no-ff --signoff --commit release-{{TAG}}
	git push origin develop
	git branch -D release-{{TAG}}

# release task(to be ran in the CI)
release-ci: static-binary
	@echo "Uploading the binary artifact for tag {{GIT_TAG}}"
	cat changelog/{{GIT_TAG}}.txt | github-release release --tag {{GIT_TAG}} --description -
	github-release upload --tag {{GIT_TAG}} --name "feeder-{{GIT_TAG}}-x86_64-unknown-linux-musl" --file target/x86_64-unknown-linux-musl/release/feeder
	@echo "Docker image release for tag {{GIT_TAG}}"
	just docker-image-release

# login into the github docker package registry
_docker_preps:
	@docker login docker.pkg.github.com -u ${GITHUB_USERNAME} -p ${GITHUB_TOKEN}
	cp config/Rocket.toml docker/Rocket.toml
	cp target/x86_64-unknown-linux-musl/release/feeder docker/feeder

# build the develop docker image
docker-image-develop: static-binary _docker_preps
	docker build -t feeder:develop -f docker/Dockerfile-dev ./docker
	docker tag feeder:develop docker.pkg.github.com/${GITHUB_USERNAME}/feeder/feeder:develop
	docker push docker.pkg.github.com/${GITHUB_USERNAME}/feeder/feeder:develop
	./ci/test_docker.sh develop

# build the release docker image, requires the tag
docker-image-release: static-binary _docker_preps
	docker build -t feeder:{{GIT_TAG}} -f docker/Dockerfile ./docker
	docker tag feeder:{{GIT_TAG}} docker.pkg.github.com/${GITHUB_USERNAME}/feeder/feeder:{{GIT_TAG}}
	docker push docker.pkg.github.com/${GITHUB_USERNAME}/feeder/feeder:{{GIT_TAG}}
	./ci/test_docker.sh {{GIT_TAG}}
