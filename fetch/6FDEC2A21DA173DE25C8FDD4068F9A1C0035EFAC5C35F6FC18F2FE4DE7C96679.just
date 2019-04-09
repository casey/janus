# postgresql shell
shell:
  docker-compose exec postgresql psql -U postgres r2dbc

# open adminer UI
ui:
  open http://localhost:8888/
