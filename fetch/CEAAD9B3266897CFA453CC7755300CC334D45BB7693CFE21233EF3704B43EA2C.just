ci:
    @hlint .
    @yamllint .hlint.yaml
    @yamllint .stylish-haskell.yaml

size:
    @sn d target/all.min.js

build:
    @./build

script:
    @rm -f rm .ghc.environment.x86_64-linux-8.2.1
    @mkdir -p .shake
    @cp shake.hs .shake
    @cd .shake && ghc -Wall -Werror -threaded -rtsopts "-with-rtsopts=-I0 -qg -qb" -O2 shake.hs -o build
    @mv .shake/build .

view: build
    firefox target/index.html
