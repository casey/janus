commit_file := "commit"

alias b:=build

build:
    cargo build

release:
    cargo build --release

commit:
    git diff --quiet && git diff --staged --quiet || git commit -F {{commit_file}}

amend:
    git commit --amend -F {{commit_file}}

pull: commit
    git pull --rebase origin master

push: pull
    git push -f origin HEAD

install: release
    cp target/release/pd ~/.local/bin/
