name := `sed -e 's/^"//' -e 's/"$//' <<< $(toml get Cargo.toml package.name)`
version := `sed -e 's/^"//' -e 's/"$//' <<< $(toml get Cargo.toml package.version)`
target-linux := "x86_64-unknown-linux-musl"
target-windows := "x86_64-pc-windows-gnu"

alias release-linux := archive-linux
alias release-windows := archive-windows
alias build := release

build-linux:
    docker run -v cargo-cache:/root/.cargo/registry -v "$PWD:/volume" --rm -it clux/muslrust cargo build --release
    docker run -v cargo-cache:/root/.cargo/registry -v "$PWD:/volume" --rm -it clux/muslrust chown -R $(id -u):$(id -g) target

build-windows:
    cross build --release --target {{target-windows}}

strip-linux: build-linux
    strip -d target/{{target-linux}}/release/{{name}}

strip-windows: build-windows
    strip -d target/{{target-windows}}/release/{{name}}.exe

archive-linux: strip-linux
    -rm target/{{target-linux}}/release/{{name}}-linux-{{version}}.zip
    zip target/{{target-linux}}/release/{{name}}-linux-{{version}}.zip target/{{target-linux}}/release/{{name}}

archive-windows: strip-windows
    -rm target/{{target-windows}}/release/{{name}}-win-{{version}}.zip
    zip target/{{target-windows}}/release/{{name}}-win-{{version}}.zip target/{{target-windows}}/release/{{name}}.exe

release: archive-linux archive-windows