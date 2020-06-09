run: build
	cargo run $CARGO_FLAGS

test: rust-test js-test

rust-test:
	cargo test --all $CARGO_FLAGS

js-test:

build: rust js css

rust:
	cargo build $CARGO_FLAGS

js: materialize
	cd client && npm run-script build

css: materialize
	cd client && npm run-script css

materialize:
	wget -nc -O client/style/materialize.css https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css || true
	wget -nc -O client/style/materialize-icons.css "https://fonts.googleapis.com/icon?family=Material+Icons" || true
	wget -nc -O client/materialize.js https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js || true

sql:
	docker-compose exec db psql -U webcord
