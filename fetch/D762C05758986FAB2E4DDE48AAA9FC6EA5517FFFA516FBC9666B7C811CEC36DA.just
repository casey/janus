DEFAULT: ci
cargo := "cargo"

build:
    {{cargo}} build

run +args="":
    {{cargo}} run -- {{args}}

clean:
    rm -fr "{{justfile_directory()}}/target"

install:
    {{cargo}} install --path "{{justfile_directory()}}"

uninstall:
    {{cargo}} uninstall "$({{cargo}} pkgid)"

ci: check test fmt clippy audit

check:
    {{cargo}} check

test:
    {{cargo}} test

fmt:
    {{cargo}} fmt --all -- --check

clippy:
    {{cargo}} clippy -- -D warnings

audit:
    {{cargo}} audit
