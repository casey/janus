test: build
    ./target/debug/pll -i 50ms -- '[[ $(($RANDOM % 10)) == 5 ]]'

build:
    cargo build

fmt:
    cargo fmt

release:
    cargo build --release
    cp target/release/pll ~/local/bin/
    chmod +x ~/local/bin/pll
