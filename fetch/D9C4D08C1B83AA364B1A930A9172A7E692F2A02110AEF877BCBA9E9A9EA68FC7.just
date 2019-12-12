# export LUA_PATH := "d:\\soft\\openresty\\lualib\\?.lua"

@watch:
  echo 'watch start'
  watchexec -p -w conf -- just reload

@start:
  echo 'openresty start'
  openresty -p `pwd` -c conf/nginx.conf

stop:
  openresty -s stop -p `pwd` -c conf/nginx.conf

@reload:
  echo 'reload ok'
  openresty -s reload -p `pwd` -c conf/nginx.conf

test +path="":
  curl localhost:8080{{path}}

@tail_error:
  echo 'error start'
  rm -f logs/error.log
  touch logs/error.log
  tail -f -n 100 logs/error.log

@tail_access:
  echo 'access start'
  rm -f logs/access.log
  touch logs/access.log
  tail -f -n 100 logs/access.log

@redis:
  redis-server