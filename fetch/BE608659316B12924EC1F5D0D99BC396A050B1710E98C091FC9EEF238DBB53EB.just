help:
  cargo run --package @appName@ --bin @appName@ -- --help

help-complete:
  cargo run --package @appName@ --bin @appName@ -- help complete

shell-zsh:
  cargo run --package @appName@ --bin @appName@ -- complete --zsh

shell-bash:
  cargo run --package @appName@ --bin @appName@ -- complete --bash
