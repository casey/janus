kernel_release = "4.14.83"
kernel_source = "linux-" + kernel_release
kernel_archive = kernel_source + ".tar.xz"
kernel_url = "https://cdn.kernel.org/pub/linux/kernel/v4.x/" + kernel_archive
kernel_defconfig = "smugloader_defconfig"
export ARCH = "x86_64"

# Build everything
all: initramfs kernel

# Run in QEMU
run +QEMU_ARGS='': all
	qemu-system-x86_64 {{QEMU_ARGS}} \
		-kernel build/bzImage \
		-initrd build/smugloader.cpio.xz \
		-drive id=disk,file=disk.img,if=none \
		-device ahci,id=ahci \
		-device ide-drive,drive=disk,bus=ahci.0

# Remove all temporary files and build artifacts
clean:
	rm -rf target *_defconfig.old \
		build/{bzImage,initrd,*.cpio.xz,linux_build}

# Build smugloader and pack the initramfs
@initramfs:
	cargo build --release
	mkdir -p build/initrd/{dev,proc,sys,mnt}
	cp target/x86_64-unknown-linux-musl/release/smugloader build/initrd/init
	strip build/initrd/init
	cd build/initrd \
		&& find -mindepth 1 -printf '%P\0' \
		| LANG=C bsdcpio -0 -o -H newc -R +0:+0 \
		| xz -C crc32 \
		> ../smugloader.cpio.xz

_kernel_prepare:
	#!/bin/sh
	set -e
	mkdir -p build
	if [ ! -f build/{{kernel_archive}} ]; then
		wget {{kernel_url}} -O build/{{kernel_archive}}
	fi
	if [ ! -d build/{{kernel_source}} ]; then
		rm -rf build/linux_build
		tar xJf build/{{kernel_archive}} -C build
	fi
	if [ ! -d build/linux_build ]; then
		mkdir build/linux_build
		cp {{kernel_defconfig}} build/linux_build/.config
		make -C build/{{kernel_source}} O=../linux_build olddefconfig
	fi

# Build the kernel
@kernel: _kernel_prepare
	make -C build/linux_build -j$(nproc)
	cp build/linux_build/arch/x86/boot/bzImage build

# Kernel menuconfig
@menuconfig: _kernel_prepare
	make -C build/linux_build menuconfig

# Save kernel config
@saveconfig: _kernel_prepare
	make -C build/linux_build savedefconfig
	mv {{kernel_defconfig}}{,.old}
	cp build/linux_build/defconfig {{kernel_defconfig}}

# vim: set ft=make tw=80 :
