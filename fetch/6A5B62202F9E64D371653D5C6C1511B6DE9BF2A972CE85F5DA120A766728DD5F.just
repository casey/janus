readme:
	cargo readme > README.md

clean:
	cargo clean
	find . -type f -name "*.orig" -exec rm {} \;
	find . -type f -name "*.bk" -exec rm {} \;
	find . -type f -name ".*~" -exec rm {} \;

lint:
	cargo clippy

build:
	cargo build

graphql:
	graphql-client introspect-schema https://gitlab.com/api/graphql > src/graphql/schema.json

check:
	cargo check

# check tests for errors
check-test:
	cargo check --tests

# print diff of what fmt would do to the codebase
fmt-check:
	cargo fmt -- --check

unit-tests:
	cargo test config_unit_tests -- --test-threads=1 --skip integration
	cargo test -- --skip config_unit_tests --test-threads=1 --skip integration

int-tests:
	cargo test config_unit_tests -- --test-threads=1 --skip unit
	cargo test -- --skip config_unit_tests --test-threads=1 --skip unit

all-tests:
	cargo test config_unit_tests -- --test-threads=1
	cargo test -- --skip config_unit_tests --test-threads=1

test TEST:
	cargo test {{TEST}} -- --test-threads=1 --show-output

tarp:
	cargo tarpaulin

branch := `git rev-parse --abbrev-ref HEAD`
last_tag := `git tag --sort=v:refname | tail -1`
cargo_ver := `grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/"//g'`
pwd := `pwd`

bump-major:
	test {{branch}} == "master"
	test {{last_tag}} == {{cargo_ver}}
	cargo bump major
	cargo update
	cargo readme > README.md
	git add Cargo.lock Cargo.toml README.md
	git commit -m "rel: $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')"
	git tag  $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')
	./ci/changelog.sh > CHANGELOG.md
	git add CHANGELOG.md
	git commit -m "docs: update CHANGELOG.md"
	git push; git push --tags

bump-minor:
	test {{branch}} == "master"
	test {{last_tag}} == {{cargo_ver}}
	cargo bump minor
	cargo update
	cargo readme > README.md
	git add Cargo.lock Cargo.toml README.md
	git commit -m "rel: $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')"
	git tag  $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')
	./ci/changelog.sh > CHANGELOG.md
	git add CHANGELOG.md
	git commit -m "docs: update CHANGELOG.md"
	git push; git push --tags

bump-patch:
	test {{branch}} == "master"
	test {{last_tag}} == {{cargo_ver}}
	cargo bump patch
	cargo update
	cargo readme > README.md
	git add Cargo.lock Cargo.toml README.md
	git commit -m "rel: $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')"
	git tag  $(grep version Cargo.toml | head -1 | awk '{print $3}' | sed 's/\"//g')
	./ci/changelog.sh > CHANGELOG.md
	git add CHANGELOG.md
	git commit -m "docs: update CHANGELOG.md"
	git push; git push --tags

musl:
	docker run -it --rm \
	-v {{pwd}}:/workdir \
	-v ~/.cargo/git:/root/.cargo/git \
	-v ~/.cargo/registry:/root/.cargo/registry \
	registry.gitlab.com/rust_musl_docker/image:stable-latest \
	cargo build --release --target=x86_64-unknown-linux-musl

