alias b := build
alias br := build-release
alias c := check
alias r := run
alias rr := run-release
alias t := test
alias tc := test-crate

build:
	cargo watch --clear --exec build

build-release: 
	cargo build --release

check: 
	cargo watch --clear --exec check

test: 
	cargo watch --clear --ignore dump --shell "cargo test -- --nocapture"

test-crate CRATE:
	RUST_LOG=debug cargo watch --clear --shell "cargo test {{CRATE}} -- --nocapture"

run:
	cargo watch --clear --exec run

run-release: 
	cargo run --release

# clean up feature branch BRANCH
done BRANCH:
	git checkout master
	git diff --no-ext-diff --quiet --exit-code
	git pull --rebase origin master
	git diff --no-ext-diff --quiet --exit-code {{BRANCH}}
	git branch -D {{BRANCH}}

publish:
	cargo build
	cargo publish
