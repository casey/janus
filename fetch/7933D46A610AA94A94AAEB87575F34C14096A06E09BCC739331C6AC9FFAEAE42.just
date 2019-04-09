deploy ssh-host:
    cargo build --release && scp target/release/pour {{ssh-host}}:~/.
