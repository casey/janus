all: check docs test run

check:
	cargo check
docs:
	cargo doc
	# cargo src
test:
	cargo test
run:
	cargo run

watch TARGET="all":
	watchexec -cre rs "just {{TARGET}}"

outdated-deps:
	cargo outdated -R
