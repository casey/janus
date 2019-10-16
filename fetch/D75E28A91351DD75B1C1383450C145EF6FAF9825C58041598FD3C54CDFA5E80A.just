all: build test

build:
    cargo build

clippy:
    cargo +stable clippy

fmt:
    cargo +stable fmt

doc:
    cargo doc --no-deps -p lvm
    cargo doc --no-deps

test:
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    # sudo firewall-cmd --zone=libvirt --add-port=8000/tcp

    cd vagrant

    if [[ ! -f "ssh-config.tmp" ]]; then
        vagrant ssh-config > ssh-config.tmp
    fi

    # Use debug builds by default
    if [[ -f "../target/debug/updater" ]]; then
        bin="../target/debug/updater"
    elif [[ -f "../target/release/updater" ]]; then
        bin="../target/release/updater"
    else
        echo "No binary found!"
        exit 1
    fi

    scp -F ssh-config.tmp -r "${bin}" ../test/client/* clipos_updater: > /dev/null
    ssh -F ssh-config.tmp clipos_updater ./run.sh

serve:
    cd webroot && simple-http-server --nocache -t 2 --cert ../test/server/update.clip-os.org.p12

serve-nohttps:
    cd webroot && simple-http-server --nocache -t 2

package:
    #!/usr/bin/env bash
    set -o errexit -o nounset -o pipefail

    readonly repo_root_path="$(cosmk repo-root-path)"
    if [[ -z "${repo_root_path}" ]]; then
        echo "[!] Not in a CLIP OS toolkit environment!"
        exit 1
    fi

    readonly updater_version="$(grep version Cargo.toml | head -1 | awk '{ print $3 }' | tr -d \")"
    readonly lvm_version="$(grep version lvm/Cargo.toml | head -1 | awk '{ print $3 }' | tr -d \")"
    readonly ebuild="updater-${updater_version}.ebuild"
    readonly ebuild_local="${repo_root_path}/src/portage/clipos/sys-apps/updater/.updater.ebuild.0"
    readonly ebuild_sdk="/mnt/src/portage/clipos/sys-apps/updater/${ebuild}"
    readonly assets_distfiles="${repo_root_path}/assets/distfiles"
    readonly commit="$(git rev-parse HEAD)"

    # Make sure that dependencies are updated
    # cargo update

    # Make sure that the code compiles and can be packaged
    # cargo package

    # Generate a template ebuild. This tools can be installed with:
    # $ cargo install cargo-ebuild
    cargo ebuild

    # Undo changes to Cargo.lock
    git checkout HEAD -- Cargo.lock

    # Set current HEAD as CROS_WORKON_COMMIT
    sed -i "s/CROS_WORKON_COMMIT=\".*\"/CROS_WORKON_COMMIT=\"${commit}\"/" "${ebuild_local}"

    # Interactively update depencies
    vimdiff "${ebuild}" "${ebuild_local}"

    # Remove now unneeded generated ebuild
    rm -f "${ebuild}"

    # Remove the lvm & updater crates dependencies if they are added by mistake
    sed -i "/^updater-${updater_version}$/d" "${ebuild_local}"
    sed -i "/^lvm-${lvm_version}$/d"         "${ebuild_local}"

    # 'Vendor/download' all dependencies
    cargo local-registry --sync Cargo.lock crates-io > /dev/null

    # FIXME: Find a cleaner way to do this.
    rm -f "${assets_distfiles}"/*.crate

    # Add needed crates to assets/distfiles
    mv crates-io/*.crate "${assets_distfiles}"

    # Remove temporary crates-io folder
    rm -rf "./crates-io"

    # Update ebuild Manifest
    cosmk run clipos/core -- ebuild "${ebuild_sdk}" manifest --force

# vim: set ts=4 sts=4 sw=4 et ft=sh:
