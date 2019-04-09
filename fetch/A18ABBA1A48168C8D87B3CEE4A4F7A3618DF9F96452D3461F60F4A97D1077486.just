version = `cat Cargo.toml | grep version | cut -d'"' -f2`
revision = `cat Cargo.toml | grep revision | cut -d'"' -f2`

target = "armv7-unknown-linux-gnueabihf"

build:
    cargo build --target={{target}}

test:
    cargo test

check-coverage:
    cargo tarpaulin --exclude-files '*/test.rs' --skip-clean --ignore-tests -v

package:
    cargo deb --target={{target}}

release:
    package_cloud push bespoke-binary/provel/debian/stretch target/{{target}}/debian/display_{{version}}-{{revision}}_armhf.deb

shipit:
    ssh root@beaglebone systemctl stop display
    scp target/{{target}}/debug/display root@beaglebone:/usr/bin/display
    ssh root@beaglebone systemctl start display

start-cross-build:
    docker-compose run --rm build bash
