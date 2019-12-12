project := 'taragram'

export PATH := `echo "$(pwd)/.rocks/bin:$PATH"`
export LUA_PATH := 'src/?.lua;src/?/init.lua;;'
rocksinstall := 'tarantoolctl rocks install --server=https://luarocks.org'

_list:
  @just --list

install-deps:
  {{rocksinstall}} httoolsp

install-dev-deps: install-deps
  for dep in moonscript inotify moonpick luacheck; do {{rocksinstall}} "$dep"; done

build:
  moonc src/

watch: build
  moonc src/ -w

lint: build
  find src/ -name '*.moon' -print -exec moonpick {} \;
  luacheck src/
