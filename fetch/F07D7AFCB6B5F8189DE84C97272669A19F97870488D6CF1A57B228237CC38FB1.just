
deploy:
  cargo web deploy
  cd target/deploy/; zip -r ludem_dare_45.zip *
  cp target/deploy/ludem_dare_45.zip .

start:
  cargo web start

check:
  cargo check

recheck:
  cargo watch -x check

run:
  cargo run

rerun:
  cargo watch -x run
