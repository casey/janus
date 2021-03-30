# Build TVM and other native libraries.
build:
    #!/bin/bash
    export LLVM_CONFIG_PATH=$(which llvm-config)
    (cd tvm/build && ninja)

# Initialize the TVM submodule.
# Run this when getting setup for the first time.
init-tvm:
    #!/bin/bash
    export LLVM_CONFIG_PATH=$(which llvm-config)
    git submodule update --init --recursive
    mkdir -p tvm/build
    pushd .
    cp config/default.config.cmake tvm/build/config.cmake
    cd tvm/build
    cmake -G Ninja -DUSE_LLVM=$LLVM_CONFIG_PATH ..
    popd

# Run the test suite.
test: build
    #!/usr/bin/env bash
    set -e
    export LD_LIBRARY_PATH="$PWD/tvm/build/"
    export PYTHONPATH="$PWD/tvm/python:$PWD/tvm/topi/python:${PYTHONPATH}"
    cargo test

# Run Cargo with all TVM environent variables.
run *ARGS: build
    #!/usr/bin/env bash
    set -e
    export LD_LIBRARY_PATH="$PWD/tvm/build/"
    export PYTHONPATH="$PWD/tvm/python:$PWD/tvm/topi/python:${PYTHONPATH}"
    cargo run {{ARGS}}

# Clean TVM and native build artifacts.
clean:
    cd tvm && ninja clean
