# just docs: https://github.com/casey/just

set shell := ["bash", "-c"]

# E.g. 'my.app.com'. Some services e.g. auth need know the external endpoint for example OAuth
# The root domain for this app, serving index.html
export APP_FQDN                    := env_var_or_default("APP_FQDN", "app1.dev")
export APP_PORT                    := env_var_or_default("APP_PORT", "443")

export APP_ORIGIN                  := "https://" + APP_FQDN + ":" + APP_PORT

# If NODE_ENV set and its value is "development", activate non-production logging, etc
# I'm not sure if this is actually needed by this application anymore
# export NODE_ENV                    := env_var_or_default("NODE_ENV", "production")

# For building the client bindings
export GRAPHQL_DOMAIN              := env_var_or_default("GRAPHQL_DOMAIN", `if [ -f /.dockerenv ]; then echo graphql ; else echo localhost ; fi`)
export HASURA_GRAPHQL_ADMIN_SECRET := env_var_or_default("HASURA_GRAPHQL_ADMIN_SECRET", "notactuallysecret")
export PORT_GRAPHQL                := env_var_or_default("PORT_GRAPHQL", "8080")
export PORT_BROWSER                := env_var_or_default("PORT_BROWSER", "8000")
# browser hot-module-replacement (live reloading)
export PORT_HMR                    := env_var_or_default("PORT_HMR", "3456")
# see https://github.com/parcel-bundler/parcel/issues/2031
PARCEL_WORKERS                     := env_var_or_default("PARCEL_WORKERS", `if [ -f /.dockerenv ]; then echo "1" ; fi`)
parcel                             := "PARCEL_WORKERS=" + PARCEL_WORKERS +  " node_modules/parcel-bundler/bin/cli.js"
tsc                                := "./node_modules/typescript/bin/tsc"

# see ../justfile
# This source is hard-coded though since the local source is at .cloudseed/deno
# DENO_SOURCE                        := "https://deno.land/x/cloudseed@0.0.8"
DENO_SOURCE                        := `dirname $(dirname $PWD)` + "/.cloudseed/deno"

# minimal formatting, bold is very useful
bold     := '\033[1m'
normal   := '\033[0m'

_help:
    @just --list

# Delete generated source files
@clean:
    # Currently empty

# Generate graphql bindings from the running graphql service: src/graphql/queries.graphql => src/graphql/generated/types.tsx
@generate: _ensureDeno clean
    echo -e "🚪 <app/browser/> {{bold}}deno run --unstable --allow-all {{DENO_SOURCE}}/graphql/generate.ts{{normal}} 🚪 "
    deno run --unstable --allow-all {{DENO_SOURCE}}/graphql/generate.ts

# Build the client static files
build +args="": (_typescript "--project .")
    @# APP_ORIGIN is used everywhere else, but for the static production builds, explicitly remove it
    @# since we do not want to bake into the client assets where the graphql server is, we just
    @# use the browser origin
    APP_ORIGIN= {{parcel}} build {{args}} public/index.html

# Run the browser dev server (optionally pointing to any remote app)
dev remote="": _typescript
    #!/usr/bin/env bash
    # Running inside docker requires modified startup configuration, HMR is disabled
    if [ -f /.dockerenv ]; then
        echo "💥 Missing feature: parcel (builds browser assets) cannot be run in development mode in a docker container"
        {{parcel}} --cert ../ingress/https/conf.d/certs/${APP_FQDN}.pem \
                   --key  ../ingress/https/conf.d/certs/${APP_FQDN}-key.pem \
                   --port ${PORT_BROWSER} \
                   --host 0.0.0.0 \
                   --hmr-hostname ${APP_FQDN} \
                   --hmr-port ${PORT_HMR} \
                   public/index.html
    else
        APP_ORIGIN=https://${APP_FQDN}:${APP_PORT}
        if [ "{{remote}}" != "" ]; then
            export APP_ORIGIN=https://{{remote}};
            echo "👉 login/logout does not work correctly pointing to a remote URL: ensure you are *already* logged in @ ${APP_ORIGIN}"
        fi
        echo "Browser development pointing to: ${APP_ORIGIN}"
        just ../ingress/https/mkcert ignorechecks
        if ! cat /etc/hosts | grep "$APP_FQDN" &> /dev/null; then
            echo -e "";
            echo -e "💥Add to /etc/hosts:💥";
            echo -e "";
            echo -e "      {{bold}}127.0.0.1    ${APP_FQDN}{{normal}}";
            echo -e "";
            exit 1;
        fi
        echo "Browser development pointing to: ${APP_ORIGIN}"
        {{parcel}} --cert ../ingress/https/conf.d/certs/${APP_FQDN}.pem \
                   --key  ../ingress/https/conf.d/certs/${APP_FQDN}-key.pem \
                   --port ${PORT_BROWSER} \
                   --host ${APP_FQDN} \
                   --hmr-hostname ${APP_FQDN} \
                   --hmr-port ${PORT_HMR} \
                   public/index.html --open
    fi

# Special configuration to develop with different domains locally to allow debugging e.g. cookies, CORS, auth
dev_different_domains_local alternative_fqdn="app.localhost":
    #!/usr/bin/env bash
    # Set the target origin before we change our own domain. APP_ORIGIN gets consumed by the browser build
    export APP_ORIGIN=https://${APP_FQDN}:${APP_PORT}
    export APP_FQDN={{alternative_fqdn}}
    echo "APP_ORIGIN=${APP_ORIGIN}"
    echo "APP_FQDN=${APP_FQDN}"
    echo "APP_PORT=${APP_PORT}"
    echo "PORT_BROWSER=${PORT_BROWSER}"
    echo "PORT_HMR=${PORT_HMR}"
    just ../ingress/https/mkcert ignorechecks
    if ! cat /etc/hosts | grep "$APP_FQDN" &> /dev/null; then
        echo -e "";
        echo -e "💥Add to /etc/hosts:💥";
        echo -e "";
        echo -e "      {{bold}}127.0.0.1    ${APP_FQDN}{{normal}}";
        echo -e "";
        exit 1;
    fi
    echo "Browser development pointing to: ${APP_ORIGIN}"
    {{parcel}} --cert ../ingress/https/conf.d/certs/${APP_FQDN}.pem \
               --key  ../ingress/https/conf.d/certs/${APP_FQDN}-key.pem \
               --port ${PORT_BROWSER} \
               --host ${APP_FQDN} \
               --hmr-hostname ${APP_FQDN} \
               --hmr-port ${PORT_HMR} \
               public/index.html --open

# compile typescript src, may or may not emit artifacts
_typescript +args="": _ensure_npm_modules
    {{tsc}} {{args}}

# rebuild the client on changes, but do not serve
watch: generate _typescript
    {{parcel}} watch \
                --public-url ./ \
                public/index.html

# deno check
@_ensureDeno:
    if ! command -v deno &> /dev/null; then echo '💥 deno💥 is not installed (manual.md#host-requirements): https://deno.land/manual/getting_started/installation'; exit 1; fi

@_ensure_npm_modules:
    if [ ! -f "{{tsc}}" ]; then npm i; fi
