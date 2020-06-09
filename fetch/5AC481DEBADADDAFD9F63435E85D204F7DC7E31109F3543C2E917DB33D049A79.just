# Commands

build: build-rs build-kernel-module

run device: build-rs _sudo
	sudo ./target/debug/netwatch_cli {{device}}

list: build-rs _sudo
	sudo ./target/debug/netwatch_cli

# Rust

build-rs:
	cargo build

# Linux Kernel Module

is-linux:
	([ "{{os()}}" == "linux" ] && exit 0) || exit 1

build-kernel-module: is-linux 
	cd pid_inode_map && make

install-kernel-module: is-linux build-kernel-module _sudo
	cd pid_inode_map && sudo insmod pid_inode_map.ko

remove-kernel-module: is-linux _sudo
	sudo rmmod pid_inode_map

# Helpers

_sudo:
	sudo -v
