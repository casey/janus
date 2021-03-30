_list:
    @just --list

start:
    just watch run

watch CMD='check' +ARGS='':
    watchexec --watch src --restart --clear just {{CMD}} {{ARGS}}

check +ARGS='':
    cargo check {{ARGS}}

run +ARGS='':
    cargo run {{ARGS}}

test +ARGS='':
    cargo test {{ARGS}}

build +ARGS='':
    cargo build {{ARGS}}
