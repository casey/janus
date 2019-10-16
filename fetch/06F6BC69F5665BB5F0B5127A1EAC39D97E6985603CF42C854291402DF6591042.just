
build: 
  cargo build

rebuild:
  cargo watch -x build

run: 
  cargo run

rerun:
  cargo watch -x run

test:
  cargo test
 
retest:
  cargo watch -x test

encode:
  cargo run -- encode test.csv data.bin

decode:
  cargo run -- decode test.csv data.bin

