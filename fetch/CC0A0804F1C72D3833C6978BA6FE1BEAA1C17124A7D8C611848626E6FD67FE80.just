init:
    docker-compose -f docker-compose.dev.yml run --rm app sh -c 'python3 manage.py createsuperuser -e fredericmhenry@gmail.com'
    docker-compose -f docker-compose.dev.yml run --rm app sh -c 'python3 manage.py createdata'

down:
    docker-compose -f docker-compose.dev.yml down

up:
    docker-compose -f docker-compose.dev.yml up -d

build:
    docker-compose -f docker-compose.dev.yml stop app
    docker-compose -f docker-compose.dev.yml rm app
    docker-compose -f docker-compose.dev.yml build app

build-restart:
    docker-compose -f docker-compose.dev.yml stop app
    docker-compose -f docker-compose.dev.yml rm app
    docker-compose -f docker-compose.dev.yml build app
    docker-compose -f docker-compose.dev.yml up -d

logs CONTAINER:
    docker-compose -f docker-compose.dev.yml logs {{ CONTAINER }}

restart CONTAINER:
    docker-compose -f docker-compose.dev.yml restart {{ CONTAINER }}

run CONTAINER +ARGS:
    docker-compose -f docker-compose.dev.yml run --rm {{ CONTAINER }} {{ARGS}}
