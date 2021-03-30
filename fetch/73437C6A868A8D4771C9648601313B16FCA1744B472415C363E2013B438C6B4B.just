target := "riscv64gc-unknown-none-elf"
mode := "release"
build-path := "../target/" + target + "/" + mode + "/"
os-firmware := build-path + "xs-core"
os-bin := build-path + "xs-core.bin"
os-asm := build-path + "xs-core.asm"
rustsbi-firmware := build-path + "rustsbi-xs"
rustsbi-bin := build-path + "rustsbi-xs.bin"
rustsbi-asm := build-path + "rustsbi-xs.asm"
img := build-path + "img.bin"


objdump := "rust-objdump"
objcopy := "rust-objcopy --binary-architecture=riscv64"

emu := env_var("NOOP_HOME") + "/build/" + "emu"

run: build
    @{{emu}} -I 1000000 -i {{img}}

build: firmware rustsbi
    @{{objcopy}} {{os-firmware}} --strip-all -O binary {{os-bin}}
    @cp {{rustsbi-bin}} {{img}}
    @dd if={{os-bin}} of={{img}} bs=128k seek=1

rustsbi:
    @cd ../rustsbi-xs && cargo build --target={{target}} --{{mode}} && {{objdump}} -D {{rustsbi-firmware}} | less > {{rustsbi-asm}} && {{objcopy}} {{rustsbi-firmware}} --strip-all -O binary {{rustsbi-bin}} && cd ../xs-core

firmware:
    @cargo build --target={{target}} --{{mode}}
    @{{objdump}} -D {{os-firmware}} | less > {{os-asm}}

asm: build
    @{{objdump}} -D {{os-firmware}} | less

clean:
    @rm -rf {{build-path}}