
run:
  cargo build
  env RUST_BACKTRACE=1 xterm -fa "PressStart2p" -fs 7 -e "./target/debug/ascii-raycaster 2> log.txt"

run-release:
  cargo build --release
  env RUST_BACKTRACE=1 xterm -fa "PressStart2p" -fs 7 -e "./target/release/ascii-raycaster 2> log.txt"

