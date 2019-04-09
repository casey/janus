build:
  cargo build

run:
  cargo run

runfufu:
  touch inbox/fufu.txt
  cargo run

runrelease:
  cargo run --release

finseq:
  rm outbox/external.txt
