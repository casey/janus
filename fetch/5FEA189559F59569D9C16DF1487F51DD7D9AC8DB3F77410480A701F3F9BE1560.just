setup:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker buildx create --platform linux/arm64,linux/amd64,linux/arm/v7 --name cross-builder --append
    docker buildx use cross-builder

enable-qemu:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

build:
    exec ./build.sh

run target arch="amd64":
    #!/usr/bin/env bash
    set -Eeuo pipefail
    ./build.sh -t "{{target}}" -p "linux/{{arch}}"
    docker run --rm -it "{{target}}_linux_{{arch}}" sh
