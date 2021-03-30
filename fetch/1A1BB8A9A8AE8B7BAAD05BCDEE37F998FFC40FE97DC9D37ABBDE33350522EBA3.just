pi_target := "armv7-unknown-linux-gnueabihf"

pi-controller:
    cross build -p samwise-controller --target {{pi_target}} --release

local-controller:
    cargo build -p samwise-controller --release

local-agent:
    cargo build -p samwise-agent --release

sync: pi-controller
    scp target/{{pi_target}}/release/samwise-controller pi@faramir.local:
    scp example-config/controller.toml pi@faramir.local:

start-agent: local-agent
    sudo ./target/release/samwise-agent --config example-config/agent_linux.toml
