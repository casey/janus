start:
  docker-compose up -d
stop:
  docker-compose down
enter:
  #!/usr/bin/env bash
  docker-compose exec forum bash

  FORUM=$(docker inspect -f '{{ "{{" }} .Name {{ "}}" }}' $(docker-compose ps -q forum) | cut -c2-)
  tmpfile="$(mktemp)"
  docker container cp ${FORUM}:/app/composer.json "$tmpfile"
  diff docker/composer.json "$tmpfile" | grep -E '^>'
  rm "$tmpfile"
build name='myflaruminstall:latest':
  #!/usr/bin/env bash
  (
    build_args=""
    source .env
    if [ -n "$EXTIVERSE_TOKEN" ]; then build_args="$build_args --build-arg EXTIVERSE_TOKEN=$EXTIVERSE_TOKEN"; fi
    cd docker
    docker image build --no-cache --target=production $build_args -t {{name}} .
  )
update:
    #!/usr/bin/env bash
    FORUM=$(docker inspect -f '{{ "{{" }} .Name {{ "}}" }}' $(docker-compose ps -q forum) | cut -c2-)
    docker container cp ${FORUM}:/app/composer.json docker/composer.json
    docker container cp ${FORUM}:/app/composer.lock docker/composer.lock
    git diff -U0 docker/composer.json | grep -E '^[+-] ' || true
loadsql file:
  #!/usr/bin/env bash
  gzip -dc {{file}} | docker-compose exec -T db mysql --user=$MYSQL_USER --password="$MYSQL_PASSWORD" $MYSQL_DATABASE
  if [ ! -f data/forum/conf/config.php ]; then docs/template_config.sh; fi
cycle:
  just stop
  docker-compose build
  just start
  just enter
