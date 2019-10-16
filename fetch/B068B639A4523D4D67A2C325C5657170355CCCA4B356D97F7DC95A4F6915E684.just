# This is a `justfile`, which is sort of like a less crufty makefile.
# It's processed using https://github.com/casey/just, which you can
# install using `cargo install -f just`.
#
# To see a list of available commands, run `just --list`.
#
# To make an alpha release:
#
# 1. Run `just set-version 0.x.y-alpha.z`, where `0.x.y` will be the next
#    release.
# 2. Run `just publish-image`.
# 3. Grab `bin/debug/falconeri-worker` and rebuild your worker image.
# 4. Run `cargo run -p falconeri -- deploy` to update `falconerid`.

# This should be either "debug" or "release". You can pass `mode=release` on
# the command line to perform a release build.
MODE = "debug"

# Look up our CLI version (which should match our other package versions).
VERSION = `cargo metadata --format-version 1 | jq -r '.packages[] | select(.name == "falconeri") | .version'`

# Print the current version.
version:
    @echo "{{VERSION}}"

# Update all versions. Usage:
#
#     just set-version 0.2.1
#
# TEMPORARY: This will have to be improved before we can make crate releases,
# because it doesn't update inter-crate dependencies.
set-version NEW_VERSION:
    #!/usr/bin/env bash
    set -euo pipefail
    for TOML in falconeri*/Cargo.toml; do
        (cd "$(dirname "$TOML")" && cargo bump {{NEW_VERSION}})
    done

# The docker image `build-falconeri`, which we use to compile things.
_build_falconeri_image:
    docker build -f Dockerfile.build -t build-falconeri .

# The container `build-falconeri-run`, which contains our binaries and docs.
#
# This uses a bash script so it can get access to more features.
_build_falconeri_container: _build_falconeri_image
    #!/usr/bin/env bash
    set -euo pipefail
    docker rm build-falconeri-container || true
    if [ "{{MODE}}" == debug ]; then
        docker run \
            -v falconeri-cargo-git:/home/rust/.cargo/git \
            -v falconeri-cargo-git:/home/rust/.cargo/registry \
            -v falconeri-target:/home/rust/src/target \
            --name build-falconeri-container \
            build-falconeri
    else
        docker run \
            -e CARGO_ARGS=--release \
            --name build-falconeri-container \
            build-falconeri
    fi

# Create a `bin/{{MODE}}/` directory with our various binaries.
static-bin: _build_falconeri_container
    mkdir -p 'bin/{{MODE}}'
    docker cp 'build-falconeri-container:/home/rust/src/target/x86_64-unknown-linux-musl/{{MODE}}/falconeri' 'bin/{{MODE}}/falconeri'
    docker cp 'build-falconeri-container:/home/rust/src/target/x86_64-unknown-linux-musl/{{MODE}}/falconerid' 'bin/{{MODE}}/falconerid'
    docker cp 'build-falconeri-container:/home/rust/src/target/x86_64-unknown-linux-musl/{{MODE}}/falconeri-worker' 'bin/{{MODE}}/falconeri-worker'

# Create a `gh-pages` directory with our "GitHub pages" documentation.
gh-pages: _build_falconeri_container
    rm -rf gh-pages
    docker cp build-falconeri-container:/home/rust/src/guide/book gh-pages

# Our `falconeri` Docker image.
image: static-bin
    docker build --build-arg MODE={{MODE}} -t faraday/falconeri:{{VERSION}} .

# This will publish our image to Docker Hub. Obviously, this requires an
# authorized account.
#
# Before doing this, update version in _all_ Cargo.toml files to a new version.
publish-image: image
    docker push faraday/falconeri:{{VERSION}}

# Check to make sure that we're in releasable shape.
check:
    cargo fmt -- --check
    cargo audit
    cargo clippy -- -D warnings
    cargo test --all

# Check to make sure our working copy is clean.
check-clean:
    git diff-index --quiet HEAD --

# PLEASE DO NOT RUN WITHOUT SIGN-OFF FROM emk. This is not a complete set of
# things that need to be done for a valid release. Some other things:
#
# 1. The top-most commit must be a valid release commit in a consistent
#    format.
# 2. We must follow an as-yet-incomplete semver policy.
#
# If you need to make an internal testing release, you should instead:
#
#     just set-version x.y.z-alpha.n
#     just publish-image
#     # Copy falconeri-worker from bin/debug
#
# Call this as:
#
#     just MODE=release release
#
release: check check-clean publish-image
    git tag v{{VERSION}}
    git push
    git push --tags
