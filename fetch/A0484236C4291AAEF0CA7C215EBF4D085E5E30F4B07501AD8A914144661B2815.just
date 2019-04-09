arch = "x86_64"
kernel = "build/kernel-" + arch + ".bin"
iso = "build/os-" + arch + ".iso"
target = arch + "-liquid_os"
rust_os = "target/" + target + "/debug/libliquid_os.a"

linker_script = "src/arch/" + arch + "/boot/layout.ld"
grub_cfg = "src/arch/" + arch + "/boot/grub.cfg"
assembly_object_file = "build/arch/" + arch + "/boot/boot.o"

asm_build_dir = "build/arch/" + arch + "/boot/"
asm_src_dir = "src/arch/" + arch + "/boot/"

current_dir = `pwd`

clean:
	cargo clean
	rm -r build

run: iso
	qemu-system-x86_64 -cdrom {{iso}} -serial mon:stdio

iso: kernel
	mkdir -p build/isofiles/boot/grub
	cp {{kernel}} build/isofiles/boot/kernel.bin
	cp {{grub_cfg}} build/isofiles/boot/grub
	grub-mkrescue -o {{iso}} build/isofiles
	rm -r build/isofiles

kernel:
	mkdir -p {{asm_build_dir}}
	nasm {{asm_src_dir}}boot.asm -felf64 -o {{asm_build_dir}}boot.o
	RUST_TARGET_PATH={{current_dir}} cargo xbuild --target {{target}}
	ld -n --gc-sections -T {{linker_script}} -o {{kernel}} {{assembly_object_file}} {{rust_os}}
	