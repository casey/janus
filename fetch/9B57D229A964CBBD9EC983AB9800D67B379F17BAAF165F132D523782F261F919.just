ci:
    yamllint src/options-en.yml
    yamllint appveyor.yml
    yamllint .travis.yml
    tomlcheck --file Cargo.toml
    cargo check
    cargo test

check:
    git diff master origin/master

bench:
    @rm -rf dhall-1.17.0
    @cabal unpack dhall
    @cargo build --release
    bench "./target/release/hr module dhall-1.17.0 'Dhall.Import' 'Dhall.Import' --benchmark-mode"
    @rm -rf dhall-1.15.1 lens-4.17
    @cabal unpack lens
    bench "./target/release/hr module lens-4.17 'Control.Lens.Internal' 'Control.Lens.Internal' --benchmark-mode"
    @rm -rf lens-4.17

packages:
    @git clone https://github.com/HuwCampbell/idris-lens.git
    cd idris-lens && cargo run -- idris . Control.Lens.Maths Control.Lens.Math && idris --build lens.ipkg
    @rm -rf idris-lens
    @cabal unpack lens
    cd lens-4.17 && cargo run -- module . "Control.Lens.Internal" "Control.Lens.Mine" --copy && cabal new-build
    @rm -rf lens-*
    @rm -rf lens-* idris-lens dhall-* language-lua-* futhark cabal

test:
    @rm -rf nothing
    @rm -rf nothing/ test-nothing
    @pi new haskell test-nothing
    cargo run -- module test-nothing "Lib" "NewLib.Nested"
    cd test-nothing && cabal new-test
    @rm -rf test-nothing nothing
    @pi new idris nothing
    cd ~/programming/idris/depends/Idris-Bifunctors/ && idris --install bifunctors.ipkg
    cargo run -- idris nothing "Nothing.Lib" "NewLib.Nested"
    cd nothing && idris --build nothing.ipkg
    @rm -rf nothing

patch:
    cargo release -l patch --no-dev-version

minor:
    cargo release -l minor --no-dev-version
