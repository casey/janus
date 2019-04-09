size:
    @sn d target/all.min.js

build:
    @./build

script:
    @mkdir -p .shake
    @cp shake.hs .shake
    @cd .shake && ghc -Wall -Werror -threaded -rtsopts "-with-rtsopts=-I0 -qg -qb" -O2 -Wall -Werror shake.hs -o build
    @mv .shake/build .

deploy: build
    cp target/* ~/programming/rust/nessa-site/static/linkedin/

view: build
    firefox-trunk target/index.html
