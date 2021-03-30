# just docs: https://github.com/casey/just
set shell     := ["bash", "-c"]
export ROOT   := env_var_or_default("GITHUB_WORKSPACE", `git rev-parse --show-toplevel`)
DENO_SOURCE   := ROOT + "/.cloudseed/deno"
bold          := '\033[1m'
normal        := '\033[0m'
green         := "\\e[32m"
yellow        := "\\e[33m"
magenta_light := "\\e[92m"

# If not in docker, get inside
_help:
    #!/usr/bin/env bash
    # https://github.com/casey/just#safer-bash-shebang-recipes
    set -euo pipefail
    if [ -f /.dockerenv ]; then
        echo -e "🌱 Cloudseed 🌱"
        echo -e "   {{bold}}$(basename $PWD){{normal}} 🚀 deployments"
        echo -e ""
        just --list --unsorted
        echo -e ""
        echo -e "Cloud deployments"
        for D in `find . -type d -mindepth 1 -maxdepth 1`
        do
            echo -e "   $D"
        done
    else
        just {{ROOT}}/cloud/_docker
    fi

# 🌱 terraform apply to all infrastructure components
apply *args="--terragrunt-non-interactive":
    #!/usr/bin/env bash
    set -euo pipefail
    for D in `find . -type d -mindepth 1 -maxdepth 1`
    do
        just $D/apply {{args}}
    done

# 🌱 TODO: What is the status of the deployment? Get some kind of summary, and hopefully a check (e.g. fail if something missing)
output:
    #!/usr/bin/env bash
    set -euo pipefail
    for D in `find . -type d` ;
    do
        just $D/output;
    done

# 🌱 terraform apply to all infrastructure components
destroy *args="":
    #!/usr/bin/env bash
    set -euo pipefail
    for D in `ls -d */`
    do
        just ${D}destroy {{args}}
    done

# 🌱 Fast development iteration: 1) git commit 2) deploy updated (versioned) resource
@develop:
    cd $ROOT ; git add -u ; git commit -m "wip@$(basename $PWD)" || true
    just apply -auto-approve --terragrunt-non-interactive

export FQDN                           := `basename $PWD`
# 🌱 Go to the live app (FQDN) (assuming there is something for the browser)
@open:
    deno run --unstable --allow-all {{DENO_SOURCE}}/exec/open_url.ts https://${FQDN}
