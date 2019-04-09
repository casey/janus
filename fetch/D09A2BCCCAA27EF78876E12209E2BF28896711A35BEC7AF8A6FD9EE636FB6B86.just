all: build

build: css js
    @cargo build

css:
    @mkdir -p resources
    @sassc -t compressed sass/style.sass resources/style.min.css

js:
    @mkdir -p resources
    @cp javascript/* resources

run: build
    @RUST_LOG=info ./target/debug/neppit

clean:
    rm -r resources target neppit.tgz

drop-tables:
    @./drop_tables.sh

build-release: css js
    @cargo build --release

run-release: build-release
    @cargo run --release

tar:
    @tar -cf neppit.tgz target/release/neppit resources templates
