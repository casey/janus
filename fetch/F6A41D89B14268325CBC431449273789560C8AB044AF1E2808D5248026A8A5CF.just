# test

run: build run-cmd
run-release: build-release run-cmd

run-bochs: build run-cmd-bochs
run-release-bochs: build-release run-cmd-bochs

run-virtualbox: build run-cmd-virtualbox
run-release-virtualbox: build-release run-cmd-virtualbox

run-cmd:
    qemu-system-i386 -m 32M -boot order=d -cdrom build/grub.iso -cpu n270 -d int,cpu_reset -no-reboot

run-cmd-bochs:
    bochs -qf bochs-config.txt -rc bochs-commands.txt

run-cmd-virtualbox:
    vboxmanage startvm "operating-system-project" --type gui

build: build-debug-binary create-grub-iso
build-release: build-release-binary create-grub-iso-release


@build-debug-binary:
    cargo xrustc --target i686-unknown-none.json -- -C link-args="--script linker-script.ld"
@build-release-binary:
    cargo xrustc --release --target i686-unknown-none.json -- -C link-args="--script linker-script.ld"

@create-grub-iso:
    mkdir -p build/iso/boot/grub 2> /dev/null | true
    cp grub.cfg build/iso/boot/grub
    cp target/i686-unknown-none/debug/operating-system-project build/iso/boot/kernel.bin
    grub-mkrescue -o build/grub.iso build/iso
@create-grub-iso-release:
    mkdir -p build/iso/boot/grub 2> /dev/null | true
    cp grub.cfg build/iso/boot/grub
    cp target/i686-unknown-none/release/operating-system-project build/iso/boot/kernel.bin
    grub-mkrescue -o build/grub.iso build/iso


clean:
	rm -fr build

create-virtualbox-vm:
    #!/usr/bin/env sh
    VM_NAME="operating-system-project"
    vboxmanage showvminfo "$VM_NAME" > /dev/null 2>&1
    if [ "$?" = "1" ]; then
        vboxmanage createvm --name "$VM_NAME" --register
        vboxmanage modifyvm "$VM_NAME" --memory 32 --pae on --keyboard ps2 --mouse ps2
        vboxmanage storagectl "$VM_NAME" --name "storage-controller" --add ide
        vboxmanage storageattach "$VM_NAME" --storagectl "storage-controller" --port 0 --device 0 --type dvddrive --medium "$PWD/build/grub.iso"
        echo "VirtualBox VM '$VM_NAME' created."
    else
        echo "VirtualBox VM '$VM_NAME' is already created."
    fi

remove-virtualbox-vm:
    vboxmanage unregistervm "operating-system-project" --delete
