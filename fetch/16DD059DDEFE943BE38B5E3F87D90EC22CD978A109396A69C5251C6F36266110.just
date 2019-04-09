server:
  hugo server -D

watch:
  hugo --watch

build:
  hugo

update: build
  cd public && git add . && git commit -m 'build' && git push origin master

publish message: update
  git add .
  git commit -m '{{message}}'
  git push origin source

restart:
  git submodule init && git submodule update && cd public && git checkout master
