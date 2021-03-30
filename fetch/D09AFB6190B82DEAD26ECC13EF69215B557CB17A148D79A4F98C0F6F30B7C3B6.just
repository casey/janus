gen:
	cargo run --release > out.wav

play:
	just gen
	aplay out.wav
