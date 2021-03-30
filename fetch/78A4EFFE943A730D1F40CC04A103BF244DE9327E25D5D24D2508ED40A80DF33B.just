setup:
	#!/bin/sh
	[ -d .ve ] || virtualenv -p python3 .ve 
	.ve/bin/pip install -r requirements3.txt
	ln -sf libyarts.so rust/target/debug/yarts.so
	ln -sf libyarts.so rust/target/release/yarts.so

build:
	cd rust ; cargo build ; cd ..

build-release:
	cd rust ; cargo build --release ; cd ..

run LOG="yarts=info,pyarts=info":
	#!/bin/sh
	. .ve/bin/activate
	export RUST_LOG={{LOG}}
	python rsmain.py

