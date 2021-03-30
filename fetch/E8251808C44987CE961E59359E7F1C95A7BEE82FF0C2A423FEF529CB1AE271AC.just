repo := "homelab-library"

@pull:
    git submodule update --init --remote
    git submodule foreach -q 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch'

create-chart name:
    #!/usr/bin/env bash
    cd charts
    just new "{{name}}"

add-container name:
    #!/usr/bin/env bash
    cd containers
    git submodule add "git@github.com:{{repo}}/{{name}}.git"

publish-container name:
    #!/usr/bin/env bash
    docker run --rm -it -u "$UID:$UID" \
        -v "$PWD/containers:/output" -v "$HOME/.config/hub:/.config/hub" \
        -w '/output/{{name}}' \
        $(docker build -q templates) \
        hub create -d "'{{name}}' container for homelab-library" "{{repo}}/{{name}}"

template t target:
    #!/usr/bin/env bash
    git init "containers/{{target}}"
    touch "containers/{{target}}/library.yml"

    docker run --rm -it -u "$UID:$UID" \
        -v "$PWD/containers:/output" \
        $(docker build -q templates) \
        templar -rf -s "name={{target}}" -d "/templates/defaults.yml" -t "/templates/{{t}}" -o "/output/{{target}}"

template-shell:
    #!/usr/bin/env bash
    docker run --rm -it -u "$UID:$UID" \
        -v "$PWD/containers:/output" \
        $(docker build -q templates)

build name:
    #!/usr/bin/env bash
    cd "containers/{{name}}/"
    docker build -t "local-{{name}}" .

buildx name:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    docker buildx use cross-builder
    cd "containers/{{name}}/"
    docker buildx build --platform linux/arm64,linux/amd64,linux/arm/v7 \
        -t "{{name}}-local" .

run name:
    #!/usr/bin/env bash
    cd "containers/{{name}}/"
    touch .env
    docker run --rm -it --env-file .env $(docker build -q .) sh

runx name arch:
    #!/usr/bin/env bash
    cd "containers/{{name}}/"
    touch .env
    docker buildx build --platform "linux/{{arch}}" -t "{{name}}-{{arch}}-local" --load .
    docker run --rm -it --env-file .env \
        --privileged \
        --net host \
        "{{name}}-{{arch}}-local" sh

publish name: (buildx name)
    #!/usr/bin/env bash
    set -Eeuo pipefail
    cd "containers/{{name}}/"
    docker buildx build --platform linux/arm64,linux/amd64,linux/arm/v7 \
        -t "homelabs/{{name}}:latest" --push .

setup:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx rm cross-builder || true
    docker buildx create --platform linux/arm64,linux/amd64,linux/arm/v7 --name cross-builder --append
    docker buildx use cross-builder

enable-qemu:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
