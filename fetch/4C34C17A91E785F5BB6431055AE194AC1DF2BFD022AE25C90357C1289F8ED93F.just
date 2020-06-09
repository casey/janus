help:
  @just --list


#
# ==============================================================================
# Dev setup:
# ==============================================================================
#


# Build development base image
build-base:
  docker build --pull -t ope-dev:latest -f Dockerfile-dev .


# Populate the node_modules by running "yarn install"
install:
  #!/usr/bin/env sh
  docker volume create ope_db_data 2> /dev/null
  docker volume create ope_yarn_cache 2> /dev/null
  docker network create ope 2> /dev/null
  just sh yarn install


# Start dev setup
up: install
  @docker-compose up -d


# Stop dev setup
stop:
  @docker-compose stop


# Down dev setup
down:
  @docker-compose down


# Logs
logs:
  @docker-compose logs -f


# Start dev setup and show logs, same as "just up; just logs"
run: up logs


# Down dev setup, remove the DB volume. Careful now, this removes all the data!
clean:
  #!/usr/bin/env sh
  read -r -p "WARNING: This removes the DB volume too, continue? [y/N] " response
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    just down
    docker volume rm ope_db_data
    docker volume rm ope_yarn_cache
    docker image rm ope-dev:latest
  fi
  echo "Clean done"


# Show container status:
ps:
  @docker-compose ps


# Launch bash shell on container
sh +args='bash':
  @docker run                                                  \
      --rm -it                                                 \
      --network ope                                            \
      -v $(pwd)/.bashrc:/root/.bashrc                          \
      -v $(pwd):/app:cached                                    \
      -v ope_yarn_cache:/usr/local/share/.cache/yarn           \
      ope-dev:latest                                           \
      {{ args }}


# Tunnel port from project network to local machine
tunnel lport host rport:
  @docker run                                                  \
    --rm -it                                                   \
    --network ope                                              \
    -p {{ lport }}:{{ rport }}                                 \
    jarppe/netspect                                            \
    socat                                                      \
      tcp-listen:{{ rport }},reuseaddr,fork                    \
      tcp:{{ host }}:{{ rport }}


# Tunnel DB to local host
tunnel-db:
  @just tunnel 27017 db 27017

tunnel-express:
  @just tunnel 8081 mongo_express 8081
