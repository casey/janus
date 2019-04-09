
@default:
	just -l

up:
	docker-compose up -d --build

dev:
	docker-compose \
		-f docker-compose.dev.yml \
		up -d --build

compose +command:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.dev.yml \
		{{ command }}

logs service='telegram' tail='all':
	just compose logs --follow --tail="{{ tail }}" "{{ service }}"

redis-monitor:
	just compose exec redis 'redis-cli monitor'

down:
	just compose down
