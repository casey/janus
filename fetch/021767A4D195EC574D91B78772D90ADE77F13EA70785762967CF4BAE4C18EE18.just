# just docs: https://github.com/casey/just
# CI (continuous integragtion)
# Automates building, testing, and deployment
#  - Commands beginning with "@" are (or will be) used for automation and are required to link to docs explaining further if needed
set shell                 := ["bash", "-c"]
ROOT                      := `dirname $(dirname $PWD)`
# See comments in app/justfile#DENO_SOURCE
DENO_SOURCE               := ROOT + "/.cloudseed/deno"
# Github is migrating from docker.pkg.github.com to ghcr.io https://docs.github.com/en/free-pro-team@latest/packages/guides/migrating-to-github-container-registry-for-docker-images
GITHUB_CONTAINER_REGISTRY := "ghcr.io"
export CI_PROVIDER        := `basename $PWD`
# minimal formatting, bold is very useful
bold                      := '\033[1m'
normal                    := '\033[0m'

@_help:
    echo "CI: automated build|test|deploy with Github Actions"
    echo ""
    just --list --unsorted
    echo ""

# 🌱 Publish versioned+tagged docker images to the configured docker registry. List images with 'just app/images'
@publish:
    GITHUB_ACTIONS=true just ../publish

# https://docs.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables
# returns the CI workspace location, where the repository is checked out and/or mounted
@workspace:
    if [[ -z "$GITHUB_WORKSPACE" ]]; then \
        echo "/repo"; \
    else \
        echo "$GITHUB_WORKSPACE"; \
    fi

# https://docs.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables
# Returns the git sha. CI environments usually supply this. For local development, git is installed in the ci image (ci/Dockerfile)
@git_tag:
    if [[ -z "$GITHUB_SHA" ]]; then \
        echo "`(which git >/dev/null && git rev-parse --short HEAD) || echo local`"; \
    else \
        echo "$GITHUB_SHA"; \
    fi

# Required. Provider specific docker registry host
@docker_registry:
    echo "{{GITHUB_CONTAINER_REGISTRY}}/"

# Required
@docker_registry_authenticate:
    if [[ -z "$GITHUB_TOKEN" ]]; then \
        echo "🚪 🔥🔥🔥 Required but missing: GITHUB_TOKEN. Set in .env or via the provider docker context 🚪 "; \
        exit 1; \
    fi && \
    echo -e "🚪 <ci/> {{bold}}echo GITHUB_TOKEN | docker login --username USERNAME --password-stdin {{GITHUB_CONTAINER_REGISTRY}}{{normal}} 🚪" && \
    echo $GITHUB_TOKEN | docker login -u USERNAME --password-stdin {{GITHUB_CONTAINER_REGISTRY}}

# if [ "$GITHUB_ACTIONS" = "true" ]; then \
#     echo -e "🚪 <ci/> {{bold}}echo INPUT_GITHUB_TOKEN | docker login --username USERNAME --password-stdin {{GITHUB_CONTAINER_REGISTRY}} {{normal}} 🚪" && \
#     echo $INPUT_GITHUB_TOKEN | docker login -u USERNAME --password-stdin {{GITHUB_CONTAINER_REGISTRY}} && \
#     exit 0; \
# fi && \

# Runs github PR test locally. Requires https://github.com/nektos/act
# @test_local:
#     echo "The docker image nektos/act-environments-ubuntu:18.04 is required for docker, but it's huge (18gb), so downloading will take a while"
#     echo "GITHUB_TOKEN=$GITHUB_TOKEN"
#     # @cd ../.. && GITHUB_TOKEN=$GITHUB_TOKEN act -s GITHUB_TOKEN=$GITHUB_TOKEN -P ubuntu-latest=nektos/act-environments-ubuntu:18.04 -j test_on_push
#     @cd ../.. && GITHUB_TOKEN=$GITHUB_TOKEN act -s GITHUB_TOKEN -P reddigit7/act-environments-ubuntu:18.04-v2 -j test_on_push

@test_local:
    DOCKER_REGISTRY=$(just docker_registry) \
    CI_PROVIDER=github \
    CI=true \
    GITHUB_ACTIONS=true \
    GITHUB_REPOSITORY=$(deno run --unstable --allow-all ../.cloudseed/deno/cloudseed/docker_image_prefix.ts)
