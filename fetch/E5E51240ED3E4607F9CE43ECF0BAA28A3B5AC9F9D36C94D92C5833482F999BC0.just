project := 'whodatbot'

export PATH := `echo "$(pwd)/.rocks/bin:$PATH"`
export LUA_PATH := 'src/?.lua;src/?/init.lua;;'
cwd := invocation_directory()
rocksinstall := 'tarantoolctl rocks install --server=https://luarocks.org'

_list:
  @just --list

sudo +args:
  @sudo --preserve-env=PATH env just {{args}}

install-deps:
  while read dep; do {{rocksinstall}} "$dep"; done < deps.txt

install-dev-deps: install-deps
  while read dep; do {{rocksinstall}} "$dep"; done < dev.deps.txt

build:
  moonc src/
  find src/ -type f -name '*.lua' -exec sed --in-place 's/[[:space:]]\+$//' {} +

watch: build
  moonc src/ -w

lint: build
  find src/ -type f -name '*.moon' -print -exec moonpick {} +
  luacheck src/

test: build
  @tarantool -e "require'busted.runner'{standalone=false};os.exit()"

connect:
  #!/bin/sh
  socket=$(yq read config.yaml console_socket) || exit 1
  [ "${socket}" = 'null' ] && exit 2
  exec tarantoolctl connect "$(readlink -f "${socket}")"

run: build
  mkdir -p db
  tarantool src/{{project}}/main.lua

docker recipe +args='':
  @just docker-{{recipe}} {{args}}

docker-build:
  docker build --pull --no-cache --force-rm --tag "{{project}}:$(date '+%y%m%d%H%M')" --tag "{{project}}:latest" .

docker-save tag:
  docker save {{project}}:{{tag}} --output {{project}}:{{tag}}.tar

docker-load filename:
  docker load --input {{filename}}

docker-run tag='latest' config_path=(cwd + '/config.yaml') db_path=(cwd + '/db') +args='':
  docker run \
    -d --restart unless-stopped \
   --log-driver journald \
    -v {{config_path}}:/opt/whodatbot/config.yaml \
    -v {{db_path}}:/var/lib/tarantool \
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
