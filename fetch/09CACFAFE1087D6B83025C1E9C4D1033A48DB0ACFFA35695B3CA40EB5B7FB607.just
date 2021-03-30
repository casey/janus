deploy: deploy-server deploy-webclient

deploy-server:
	cargo build --target=arm-unknown-linux-gnueabihf --release
	ssh $PI_HOST 'sudo systemctl stop rainbowctl'
	scp target/arm-unknown-linux-gnueabihf/release/rainbowctl $PI_HOST:~
	ssh $PI_HOST 'sudo systemctl start rainbowctl'

deploy-webclient:
	scp -r static/ $PI_HOST:~

run-tx:
	cargo build --release --bin=equalizer-tx
	cava -p cava.conf &
	./target/release/equalizer-tx
