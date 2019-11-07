bin_name := 'cgitpr'

alias r := run
alias b := build
alias i := install

clean:
    rm -rf build

build:
    #!/usr/bin/env bash
    mkdir -p build && cd build || exit 1

    # build
    cmake .. -DCMAKE_BUILD_TYPE="${1:-RelWithDebInfo}" #sh

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
        else
            echo "compile_commands.json already linked to top of project"
        fi
    else
        echo "no compile_commands.json in build directory"
    fi #sh

run:
    ./build/{{bin_name}}
