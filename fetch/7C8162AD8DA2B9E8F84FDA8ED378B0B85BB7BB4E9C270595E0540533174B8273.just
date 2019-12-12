# https://github.com/casey/just

# Get version from Cargo.toml
version := `egrep "version" Cargo.toml -m 1 | sed -e 's/version *= *//g' -e 's/"//g'`

publish-tag:
    git tag -a v{{version}} -m "" && git push origin v{{version}}

publish-crate:
    # cargo package -> inspect crate
    # cargo publish