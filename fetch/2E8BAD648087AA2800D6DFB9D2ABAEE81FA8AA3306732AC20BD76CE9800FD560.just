build:
    cargo build --release

fmt:
    rustfmt src/*.rs

clean:
    rm -rf target/release
    rm -rf target/debug
    rm -rf target/doc

snap:
    snapcraft
