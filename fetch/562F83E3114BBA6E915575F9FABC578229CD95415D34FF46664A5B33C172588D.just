# justfile: Project recipes.
#
# note:
#   When adding a new recipe, add corresponding documentation to README.md.
#
# see:
#   https://github.com/casey/just#installation

IMAGE = "kariusdx/alpine-jre"

# Lists all available recipes, their calling syntax, and synopsis. 
@help:
  just --list

# ----------------------------------------------------------------------------------------------------------------------

# Builds the `kariusdx/alpine-jre` docker image.
@build:
  docker build --tag {{IMAGE}} . 

# Publishes `kariusdx/alpine-jre` to docker hub with the given `TAGS`.
publish +TAGS='':
  #!/usr/bin/env bash
  for TAG in {{TAGS}}
  do
    echo {{IMAGE}}:${TAG}
    docker login -u "${DOCKER_USER:-kariusdocker}" -p "${DOCKER_PASS:-undefined}"
    docker tag {{IMAGE}} {{IMAGE}}:${TAG}
    docker push {{IMAGE}}:${TAG}
    docker logout
  done

# Runs a command in `kariusdx/alpine-jre`.
@run +ARGS:
  # bug: how do we capture docker OPTIONS in "docker run [OPTIONS] IMAGE [COMMAND] [ARG...]""
  docker run --rm {{IMAGE}} {{ARGS}}

# Runs a shell in `kariusdx/alpine-jre` for poking around.
@shell:
  docker run -it --rm --entrypoint /bin/bash {{IMAGE}}

# Lists the tags that point at `HEAD`.
@tags:
    git tag --points-at HEAD
