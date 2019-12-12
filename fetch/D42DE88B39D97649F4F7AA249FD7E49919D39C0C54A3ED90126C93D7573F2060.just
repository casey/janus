MODE := "release"
TARGET := "target/msp430-none-elf/" + MODE + "/at2xt"

default:
    xargo build --release --target=msp430-none-elf
    msp430-elf-objdump -Cd {{TARGET}} > {{TARGET}}.lst
    msp430-elf-readelf -s --wide {{TARGET}} > {{TARGET}}.sym
    msp430-elf-size {{TARGET}}

timer:
    xargo build --release --target=msp430-none-elf --features use-timer
    msp430-elf-objdump -Cd {{TARGET}} > {{TARGET}}.lst
    msp430-elf-readelf -s --wide {{TARGET}} > {{TARGET}}.sym
    msp430-elf-size {{TARGET}}

clean:
    xargo clean

prog:
    mspdebug rf2500 "prog {{TARGET}}"
