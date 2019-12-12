project := 'httoolsp'

_list:
  @just --list

install-dev-deps:
  luarocks install moonscript
  luarocks install moonpick
  luarocks install busted
  luarocks install luacheck

build:
  moonc src/

test: build
  busted -v spec/

lint: build
  find -name '*.moon' -print -exec moonpick {} \;
  luacheck src/
