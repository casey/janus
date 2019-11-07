watch:
	cargo watch --clear --exec 'run --release -- --simulations 100 damper 0.01 0.0'

deps:
	brew install gnuplot

build:
	cargo build --release

images: build
	./target/release/stake-ratchet --simulations 100 --output none.png damper 0.0 0.0
	./target/release/stake-ratchet --simulations 100 --output slight.png damper 0.1 0.0
	./target/release/stake-ratchet --simulations 100 --output strong.png damper 0.05 0.0
