size:
    @sn d target/all.min.js

build:
    @./shake

script:
    @mkdir -p .shake
    @cp shake.hs .shake
    cd .shake && ghc -O2 shake.hs -o shake
    @mv .shake/shake .

view: build
    firefox-trunk target/index.html
