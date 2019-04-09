build-only:
  cargo build

build: build-only setcap

setcap:
  #  To use /ping/, the application needs access to /cap_net_raw/.
  #  Enter your sudo password to automatically configure that.
  #  You can also run /just build-only/ and manually grant permission.
  #  You may inspect the exact command that is run in /Justfile/.
  sudo setcap cap_net_raw+ep target/*/u-p-seer

run:
  @./target/debug/u-p-seer