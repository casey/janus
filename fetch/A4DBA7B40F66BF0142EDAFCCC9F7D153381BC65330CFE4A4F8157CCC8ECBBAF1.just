

# Override the RUST_LOG value with custom log levels.
# When debugging gRPC, it may be useful to do `just log_level=debug run`
log_level := "wok=info"

# Location of your 'crictl.yaml' config file
crictl_yaml := "./crictl.yaml"

# Name of the socket the code starts. Only override this if you
# are sure of what you are doing. Otherwise, edit 'crictl.yaml'
# or the code.
wok_sock := "/tmp/wok.sock"

alias test := test-unit

# Execute the server in the foreground
run:
    RUST_LOG={{log_level}} cargo run -- --dir ~/.wok

# Build the server
build:
    cargo build

# Install using Cargo
install:
    RUSTFLAGS=-Awarnings cargo install -f --path .

# Build the Go libwasm2oci library
bootstrap:
    cd libwasm2oci && dep ensure -v
    GO111MODULE= CGO_ENABLED=1 go build -buildmode=c-archive -o target/libwasm2oci.a libwasm2oci/libwasm2oci.go
    bindgen -o src/oci.rs target/libwasm2oci.h --raw-line "#![allow(non_snake_case, non_camel_case_types, non_upper_case_globals)]"

# A quick test to make sure the server is executing.
server-version:
    crictl -c {{crictl_yaml}} version

# Run all available test suites.
test-all: test-unit test-integration test-benchmark

# Run the unit tests with Cargo
test-unit:
    cargo clippy
    cargo test

# Run the critest conformance suite
test-integration:
    critest --runtime-endpoint {{wok_sock}}

# Run the critest benchmarking suite
test-benchmark:
    critest --runtime-endpoint {{wok_sock}} --benchmark
