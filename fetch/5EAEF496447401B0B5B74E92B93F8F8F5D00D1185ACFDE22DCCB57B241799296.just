watch:
	cargo watch --clear --exec test

run:
	cargo run

fmt:
	cargo +nightly fmt --all

test:
	cargo test --all

clippy:
	cargo clippy --all

lint:
	./bin/lint

push: check
	! git branch | grep '* master'
	git push github

pr: push
	hub pull-request -o

check: test clippy lint
	git diff --no-ext-diff --quiet --exit-code
	cargo +nightly fmt --all -- --check

ping:
	ping6 bulb.tulip.farm

deploy:
	./bin/deploy

ssh:
	ssh root@bulb.tulip.farm

create-user:
	ssh root@bulb.tulip.farm "adduser --disabled-password --gecos '' bulb"

install-unit:
	scp bulb.service root@bulb.tulip.farm:/etc/systemd/system/bulb.service
	ssh root@bulb.tulip.farm sudo systemctl daemon-reload
	ssh root@bulb.tulip.farm sudo systemctl restart bulb.service

install-sudoers:
	scp bulb.sudoers root@bulb.tulip.farm:/etc/sudoers.d/bulb
	ssh root@bulb.tulip.farm chmod 0440 /etc/sudoers.d/bulb
