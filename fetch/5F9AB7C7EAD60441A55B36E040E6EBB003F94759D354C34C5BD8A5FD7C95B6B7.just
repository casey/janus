export RUST_BACKTRACE="1"
export RUST_LOG="grot=debug"

run +args="":
    cargo run -- {{args}}

trace +args="":
    RUST_LOG="grot=trace" cargo run -- {{args}}

help:
    cargo run -- --help

trance:
    mpv http://tunein.com/radio/radiOzora-Psy-s201024

chill:
    mpv https://tunein.com/radio/radiOzora-Chill-channel-s201021
