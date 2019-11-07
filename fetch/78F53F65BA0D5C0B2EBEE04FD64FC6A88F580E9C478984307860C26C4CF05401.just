render:
	dot -Tpng -Gdpi=300 architecture.dot -o architecture.png && open architecture.png

cargo-deps:
	cargo install watchexec

mac-deps:
	brew install graphviz
