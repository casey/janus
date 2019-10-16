# postgresql shell
postgresql:
  docker-compose exec postgresql psql -U postgres r2dbc

# open adminer UI
ui:
  open http://localhost:8888/

# mysql cli
mysql:
  mysql -hlocalhost --protocol=TCP -uroot -p123456 r2dbc