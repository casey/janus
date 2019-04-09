TOOL_PATH = "../z_tools/"

LD = env_var("HOME") + "/local/i386-elf/bin/ld"
QEMU  = "qemu-system-i386"
QEMU_ARG = "-L . -m 32 -localtime -vga std -fda"

DEL      = "rm -f"


export RUSTFLAGS='--emit=asm --emit=obj -C relocation-model=static' 

build:
	{{TOOL_PATH}}nask ipl10.nas ipl10.bin ipl10.lst
	{{TOOL_PATH}}nask asmhead.nas asmhead.bin asmhead.lst
	cd ../body ;RUST_TARGET_PATH="$(pwd)" xargo build  --target new_os --release --manifest-path="Cargo.toml"
	cp ../body/target/new_os/release/libbody.a .
	{{LD}} -gc-sections -T toy.ld -Map body.map -o body.bin -e rust_main libbody.a
	cat asmhead.bin body.bin > haribote.sys
	{{TOOL_PATH}}edimg imgin:{{TOOL_PATH}}fdimg0at.tek \
		wbinimg src:ipl10.bin len:512 from:0 to:0 \
		copy from:haribote.sys to:@: \
		imgout:haribote.img

run: build
	{{QEMU}} {{QEMU_ARG}} haribote.img

clean:
	cd ../body/.; xargo clean
	rm -f *.bin
	rm -f *.a
	rm -f *.lst
	rm -f *.map
	rm -f haribote.img 
	rm -f haribote.sys

