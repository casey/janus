phony:
    @just -l

db:
    #! /bin/bash
    echo "recreating db"
    dropdb jjs
    createdb jjs
    echo "running migrations"
    cd db
    diesel migration run
    echo "re-running migrations"
    diesel migration redo

users:
    cargo run --bin userlist -- add --auth dev_root ./example-config/userlist.txt

install_tools:
    #! /bin/bash
    cargo install diesel_cli mdbook || true