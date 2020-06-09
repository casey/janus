generator_dir := `pwd` + "/generator"
MCP := generator_dir + "/target/release/mcp"
API_INDEX_JSON := "etc/api-index.v1.json"
API_INDEX_MAPPED_JSON := "etc/api-index-mapped.v1.json"
OUTPUT_DIR := "gen"
SPEC_DIR := "etc/api"  # keep in sync with Standard::config_dir: TODO: can we write an .env file instead?
MAKEFILE_TPL := ""
CARGO_TOML_TPL := ""
GEN_MAKEFILE := OUTPUT_DIR + "/Makefile"
GEN_CARGO_TOML := OUTPUT_DIR + "/Cargo.toml"
ERRORS_FILE_SUFFIX := "-errors.log"
SKIP_MCP := "no"

# display an overview
help:
    #!/bin/sh
    cat <<EOF
    Run 'just --list' for more details, here is an overview
    -- Used most often... ---------------------------------------------------------------------------)
    'refresh-pruned-specs' and 'refresh-all'
    -- Operations on the gen/ directory  ------------------------------------------------------------)
    'gen-cargo-errors' and 'gen-cargo <+arguments>' and 'gen-make <target> <+arguments>'
    -- Developer Targets ----------------------------------------------------------------------------)
    'mcp' and 'show-errors' and 'clear-errors' and 
    EOF

# Add a brand new Google API to be generated at next refresh
add-api name version:
    #!/bin/sh
    version=$(echo {{version}} | sed 's/v//g')
    set -eux
    mkdir -p etc/api/{{name}}/v$version
    touch etc/api/{{name}}/v$version/spec.json
    mkdir -p gen/{{name}}/v$version
    touch gen/{{name}}/v$version/meta.json

# Remove a Google API version
remove-api name version:
    #!/bin/sh
    version=$(echo {{version}} | sed 's/v//g')
    echo "Removing {{name}}/v$version..."
    rm -rfv etc/api/{{name}}/v$version gen/{{name}}/v$version

# Fetch the latest API index from Googles discovery service
refresh-api-index:
    curl -S https://www.googleapis.com/discovery/v1/apis > {{API_INDEX_JSON}}
    # HACK: v3 of identitytoolkit is deprecated (confusingly v2 is the current version) 
    # and the discovery service has not been updated to reflect this
    # see: https://developers.google.com/identity/toolkit/migrate-identityplatform
    git apply etc/identitytoolkit.patch

# build or update the MCP tool, used for generation and much more
mcp:
    #!/usr/bin/env bash 
    set -eux -o pipefail
    [[ "{{SKIP_MCP}}" = "yes" ]] && exit 0
    if [ ! -d {{generator_dir}} ]; then
        git clone --depth=1 https://github.com/google-apis-rs/generator {{generator_dir}}
    else
        (cd {{generator_dir}} && git pull --ff-only)
    fi
    cd {{generator_dir}} && cargo build --release

# Using the API index and known errors, generate a pruned API index containing only working APIs
_map-api-index: mcp
    {{MCP}} map-api-index {{API_INDEX_JSON}} {{API_INDEX_MAPPED_JSON}} {{SPEC_DIR}} {{OUTPUT_DIR}}

# update files we can use to run the tooling
update-drivers: _map-api-index mcp
    cat {{API_INDEX_MAPPED_JSON}} | {{MCP}} substitute \
        templates/Makefile.liquid:{{GEN_MAKEFILE}} \
        templates/Cargo.toml.liquid:{{GEN_CARGO_TOML}}

# fetch API specifications from Google's discovery service, based on the list of ones we know work
fetch-api-specs-pruned: _map-api-index mcp
    {{MCP}} fetch-api-specs {{API_INDEX_MAPPED_JSON}} {{SPEC_DIR}} {{OUTPUT_DIR}}

# fetch API specifications from Google's discovery service, based the entire index of available APIs, and regenerate code
fetch-api-specs-google: refresh-api-index
    {{MCP}} fetch-api-specs {{API_INDEX_JSON}} {{SPEC_DIR}} {{OUTPUT_DIR}}

# fetch latest API specifications known to be working, just make it work!
refresh-pruned-specs: fetch-api-specs-pruned update-drivers

# clear errors, fetch latest index from google, and fetch all specs
refresh-with-force:
    just MCP="{{MCP}}" SKIP_MCP={{SKIP_MCP}} clear-errors generator
    just MCP="{{MCP}}" SKIP_MCP={{SKIP_MCP}} clear-errors cargo
    just MCP="{{MCP}}" fetch-api-specs-google
    just MCP="{{MCP}}" SKIP_MCP={{SKIP_MCP}} update-drivers

# clear errors, fetch latest index from google, and fetch all specs, run cargo check and doc
refresh-all: refresh-with-force collect-errors

any_error := "*"
# valid prefixes: generator or cargo
clear-errors prefix=any_error: 
    @echo Clearing all errors...
    find {{OUTPUT_DIR}} -name '{{prefix}}{{ERRORS_FILE_SUFFIX}}' -exec rm -v '{}' \;
    just MCP="{{MCP}}" SKIP_MCP={{SKIP_MCP}} update-drivers


# valid prefixes: generator or cargo or '*'
show-errors prefix=any_error:
    #!/usr/bin/env sh
    set -eu
    find {{OUTPUT_DIR}} -name '{{prefix}}{{ERRORS_FILE_SUFFIX}}' | while read -r fp; do 
        echo $"\n---> $fp <---\n"
        cat "$fp"
    done

# Best after 'refresh-all', it generates all code and runs cargo against it, collecting errors
collect-errors:
    just SKIP_MCP={{SKIP_MCP}} mcp 
    just gen-cargo-errors check
    just SKIP_MCP={{SKIP_MCP}} update-drivers
    just gen-cargo-errors doc
    just SKIP_MCP={{SKIP_MCP}} update-drivers

check := "check"
# Run cargo on the workspace with all projects
gen-cargo +arguments=check:
    cd {{OUTPUT_DIR}} && cargo {{arguments}}

# Run MCP to control Cargo to efficiently run it and store errors accordingly
gen-cargo-errors +arguments=check:
    {{MCP}} cargo-errors {{API_INDEX_MAPPED_JSON}} {{GEN_CARGO_TOML}} {{OUTPUT_DIR}} {{arguments}}

# Run make on the given target, potentially providing arguments to cargo
gen-make target +arguments=check:
    make -C {{OUTPUT_DIR}} MCP={{MCP}} {{target}} ARGS={{arguments}}
