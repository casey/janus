version := "v1.0"
image_name := "homelabs/rundeck"
arch := `echo -n ${TARGET_ARCH:-amd64}`

setup:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx create --platform linux/arm64,linux/amd64,linux/arm/v7 --name cross-builder --append
    docker buildx use cross-builder

enable-xbuild:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

build:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx build --platform linux/arm64,linux/amd64,linux/arm/v7 \
        -t "{{image_name}}" .

run:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx build --platform linux/{{arch}} --load \
        -t "{{image_name}}" .
    docker run --rm -it -p 4440:4440 \
        --env-file .env \
        -v $HOME/.ssh:/rundeck/.ssh "{{image_name}}" \
        bash

publish:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx build --platform linux/arm64,linux/amd64,linux/arm/v7 \
        -t "{{image_name}}" --push .
