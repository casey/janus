bin_name := 'cimgtool'

alias r := run
alias b := build
alias i := install

clean:
    rm -rf build

build:
    #!/usr/bin/env bash
    mkdir -p build && cd build || exit 1

    # build
    cmake .. -DCMAKE_BUILD_TYPE="${1:-RelWithDebInfo}"
    make #sh

install: build
    #!/usr/bin/env bash
    cd build || exit 1
    make install

    # link compile_commands.json for source code completion
    if [[ -f compile_commands.json ]]; then
        cd .. || exit 1
        if [[ ! -e compile_commands.json ]]; then
            echo "linking build/compile_commands.json to top dir..."
            ln -s build/compile_commands.json ./
        fi
    fi
    just run #sh

run +args='':
    ./build/{{bin_name}} ./test/sunset.jpg ./test/sunset_edited.jpg -w 2000 -vv {{args}}
