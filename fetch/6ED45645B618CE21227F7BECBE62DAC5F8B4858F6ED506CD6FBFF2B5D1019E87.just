watch-main:
  cargo watch -i "logs/**/*" -x "build --bin garage_rfid" -s "RUST_BACKTRACE=1 ./target/debug/garage_rfid"

watch-example example:
  cargo watch -i "logs/**/*" -x "build --example {{example}}" -s "RUST_BACKTRACE=1 ./target/debug/examples/{{example}}"

watch-sync:
  cargo watch -i "logs/**/*" -i ".git/**/*" -s "./sync.sh"
