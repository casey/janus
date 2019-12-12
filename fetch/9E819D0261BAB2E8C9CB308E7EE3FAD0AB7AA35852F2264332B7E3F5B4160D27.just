project := 'tinystash'

_list:
  @just --list

sudo +args:
  @sudo --preserve-env=PATH env just {{args}}

install-deps:
  #!/bin/sh
  while read dep; do opm --cwd get "$dep"; done < requirements.opm

lint:
  luacheck .

run:
  ./tinysta.sh run

docker recipe +args='':
  @just docker-{{recipe}} {{args}}

docker-build:
  docker build --pull --no-cache --force-rm --tag "{{project}}:$(date '+%y%m%d%H%M')" --tag "{{project}}:latest" .

docker-save tag:
  docker save {{project}}:{{tag}} --output {{project}}:{{tag}}.tar

docker-load filename:
  docker load --input {{filename}}

docker-run tag='latest' port='8880' +args=('-v ' + invocation_directory() + '/config.lua:/opt/tinystash/config.lua'):
  docker run \
    -d --restart unless-stopped \
    --log-driver journald \
    -p {{port}}:80 \
    {{ args }} \
    --name {{project}} {{project}}:{{tag}}

docker-start:
  docker start {{project}}

docker-stop:
  docker stop {{project}}

docker-rm: docker-stop
  docker rm {{project}}

docker-clean keep='1':
  #!/bin/sh
  project='{{project}}'
  format='{{"{{"}}.Repository{{"}}"}}:{{"{{"}}.Tag{{"}}"}}'
  keep='{{keep}}'
  to_delete=$(docker image ls \
    --filter="reference=${project}" \
    --format="${format}" \
    | sed -e '/:latest$/d' \
    | sed -e "1,${keep}d" \
    | tr '\n' ' '
  )
  delete_msg="delete all ${project} images except the last ${keep}"
  if [ -z "${to_delete}" ]; then
    echo "*** ${delete_msg}: nothing to delete"
  else
    echo "*** ${delete_msg}: ${to_delete}"
    # shellcheck disable=SC2086
    eval docker image rm ${to_delete}
  fi
  echo '*** prune unused images'
  docker image prune --force
