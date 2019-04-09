size:
    @sn d target/all.min.js

script:
    @mkdir -p .shake
    @cp shake.hs .shake
    cd .shake && ghc -Wall -Werror -O2 shake.hs -o build
    @mv .shake/build .

view:
    firefox target/index.html
