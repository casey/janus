project := 'httoolsp'

dev_deps := 'moonscript moonpick busted luacheck ldoc'

cwd := invocation_directory()

export LUA_PATH := cwd + '/src/?.lua;' + cwd + '/src/?/init.lua;'

_list:
  @just --list

install-dev-deps:
  for dep in {{dev_deps}}; do luarocks install $dep; done

build:
  moonc src/

test: build
  busted -v spec/

lint: build
  find -name '*.moon' -print -exec moonpick {} \;
  luacheck src/

doc:
  rm -r docs || true
  ldoc .

repl: build
  rlwrap -a -H '{{cwd}}/.lua_history' lua
