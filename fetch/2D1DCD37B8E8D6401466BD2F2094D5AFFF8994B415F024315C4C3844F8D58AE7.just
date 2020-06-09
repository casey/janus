compare-min:
    xargo rustc --manifest-path=take-api/Cargo.toml --release --target=msp430-none-elf --example min -- --emit=llvm-ir=compare/min-nobare.ll,asm=compare/min-nobare.asm
    xargo rustc --manifest-path=take-api/Cargo.toml --release --target=msp430-none-elf --example min --features use-bare-metal -- --emit=llvm-ir=compare/min-bare.ll,asm=compare/min-bare.asm

bisect:
    cargo-bisect-rustc --script=./test-regress.sh --preserve-target --preserve --start=2019-03-27 --end=2019-09-04 --with-src --with-cargo

clean-bisect:
    rm -rf target-bisector-nightly-*
    rm -rf target-ci-*
