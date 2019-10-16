build: format
    cargo xbuild --target x86_64-unknown-uefi

rebuild: clean format build

format:
    cargo fmt

clean:
    cargo clean

run: build
    mkdir -p image/efi/boot
    cp target/x86_64-rust_os/debug/rust_os.efi image/efi/boot/bootx64.efi
    qemu-system-x86_64 -bios OVMF.fd -drive format=raw,file=fat:rw:image,if=ide,index=0,media=disk -nographic -vnc :0
