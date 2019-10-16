dev:
  cargo test --all --color=always -- --test-threads=1 --quiet

ci: test build clippy fmt doc

test:
  cargo test --all --color=always --features ci -- --test-threads=1 --quiet

build:
  cargo build --features=ci

clippy:
  cargo clippy

fmt:
  cargo fmt -- --check

doc:
  cargo doc

raspberry_debug: raspberry_build raspberry_debug_run

raspberry_build:
  cargo build --features=ci --release

raspberry_debug_run:
  ./raspberry_debug.sh

raspberry_debug_stop:
  pkill xinit

raspberry_deploy:
  (cd ansible && ansible-playbook -i hosts tasks.yaml)
