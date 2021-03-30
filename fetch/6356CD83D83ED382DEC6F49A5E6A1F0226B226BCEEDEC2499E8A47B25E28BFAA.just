# If NODE_ENV set and its value is "development", activate non-production logging, etc
export NODE_ENV                    := env_var_or_default("NODE_ENV", "production")

export GRAPHQL_DOMAIN              := env_var_or_default("GRAPHQL_DOMAIN", `if [ -f /.dockerenv ]; then echo graphql ; else echo localhost ; fi`)
export HASURA_GRAPHQL_ADMIN_SECRET := env_var_or_default("HASURA_GRAPHQL_ADMIN_SECRET", "notactuallysecret")
export PORT_GRAPHQL                := env_var_or_default("PORT_GRAPHQL", "8080")
PARCEL_WORKERS                     := env_var_or_default("PARCEL_WORKERS", `if [ -f /.dockerenv ]; then echo "1" ; fi`)
parcel                             := "PARCEL_WORKERS=" + PARCEL_WORKERS +  " node_modules/parcel-bundler/bin/cli.js"
tsc                                := "node_modules/typescript/bin/tsc"
ts_node_dev                        := "node_modules/ts-node-dev/lib/bin.js"

# see ../justfile
# This source is hard-coded though since the local source is at .cloudseed/deno
# DENO_SOURCE                        := "https://deno.land/x/cloudseed@0.0.8"
DENO_SOURCE                        := `dirname $(dirname $PWD)` + "/.cloudseed/deno"

# minimal formatting, bold is very useful
bold     := '\033[1m'
normal   := '\033[0m'

_help:
    @just --unsorted --list

# Generate graphql bindings from the running graphql service: src/graphql/queries.graphql => src/graphql/generated/types.tsx
@generate: _ensureDeno clean
    echo -e "🚪 <app/browser/> {{bold}}deno run --unstable --allow-all {{DENO_SOURCE}}/graphql/generate.ts{{normal}} 🚪 "
    deno run --unstable --allow-all {{DENO_SOURCE}}/graphql/generate.ts --graphql-config=src/modules/db/graphql/codegen.yml

# Build the production (or development if NODE_ENV=development) api server
build: (_typescript "--sourceMap --project .")
    {{parcel}} build --target=node --no-minify src/index.ts

# Run in development mode (automatic reloading)
dev:
    {{ts_node_dev}} --ignore-watch node_modules --transpile-only ./src/index.ts

start:
    node ./dist/index.js

test:
    NODE_ENV=test npx jest --verbose --runInBand

# Development: install a package locally and also inside the running docker container
install package:
    npm i --save {{package}}
    export TARGET=$(basename "$PWD") && cd .. && docker-compose exec $TARGET npm i --save {{package}}
    cd .. && just build

# Development: uninstall a package locally and also inside the running docker container
uninstall package:
    npm uninstall --save {{package}}
    export TARGET=$(basename "$PWD") && cd .. && docker-compose exec $TARGET npm uninstall --save {{package}}
    cd .. && just build

# compile typescript src, may or may not emit artifacts
_typescript +args="":
    {{tsc}} {{args}}

# I don't just remove 'dist/' itself because it might be moutned into a docker-compose container
@clean:
    rm -rf dist/*

# deno check
@_ensureDeno:
    if ! command -v deno &> /dev/null; then echo '💥 deno💥 is not installed (manual.md#host-requirements): https://deno.land/manual/getting_started/installation'; exit 1; fi
