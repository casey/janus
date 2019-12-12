project := 'whodatbot'

export PATH := `echo "$(pwd)/.rocks/bin:$PATH"`
export LUA_PATH := 'src/?.lua;src/?/init.lua;;'
rocksinstall := 'tarantoolctl rocks install --server=https://luarocks.org'

_list:
  @just --list

install-deps:
  {{rocksinstall}} https://raw.githubusercontent.com/un-def/taragram/master/taragram-scm-1.rockspec

install-dev-deps: install-deps
  for dep in moonscript inotify moonpick luacheck; do {{rocksinstall}} "$dep"; done

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

run: build
  mkdir -p db
  tarantool src/{{project}}/main.lua
