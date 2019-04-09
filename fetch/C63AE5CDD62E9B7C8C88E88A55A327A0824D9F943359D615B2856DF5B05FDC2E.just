all: build-release
run: run-release

test: build-debug
    #!/bin/bash
    cargo run 2> log.txt &
    while [[ ! `pidof hms_api` ]]; do sleep 1; done
    cargo test;
    result=$?;
    killall hms_api;
    echo "server log:"
    cat log.txt
    exit $result

run-release: build-release
    cargo run --release

run-debug: build-debug
    cargo run

build-release: clean-migrations
    #!/bin/bash
    cd migrations
    ln -sf ./.sqls/release
    cd ..
    cargo build --release

build-debug: clean-migrations
    #!/bin/bash
    cd  migrations
    ln -sf ./.sqls/debug
    cd ..
    cargo build

clean-migrations:
    #!/bin/bash
    if [ -a migrations/release ]; then unlink migrations/release > /dev/null; fi
    if [ -a migrations/debug ];   then unlink migrations/debug   > /dev/null; fi
    
