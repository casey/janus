install-tools:
    #!/usr/bin/env bash
    set -eux

    hash rustup || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
    source $HOME/.cargo/env
    rustup install stable

run mode="single-run":
    #!/usr/bin/env bash

    if [[ "{{os()}}" == "linux" ]]; then
        ../../atlantis-executables/atlantis.linux {{mode}} --  cargo run
    elif [[ "{{os()}}" == "macos" ]]; then
        ../../atlantis-executables/atlantis.darwin {{mode}} --  cargo run
    else
        ../../atlantis-executables/atlantis.windows.exe  {{mode}} --  cargo run
    fi

build-docker:
    docker build . -t atlantis-submission:latest

prepare-submission:
    #!/usr/bin/env bash
    set -eux

    rm -rf build
    mkdir -p build/atlantis-solution
    cp -a src *.toml *.lock Dockerfile Justfile build/atlantis-solution/
    cd build
    tar czf atlantis-solution.tar.gz atlantis-solution

    set +x

    echo
    echo "To submit, add build/atlantis-solution.tar.gz to https://forms.gle/utQt8xdeDg9KY8Rz6"
