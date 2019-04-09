poly:
    @rm -f fast-arithmetic/*.c
    @poly -e cbits

linguist:
    linguist

ci:
    cd fast-arithmetic && atspkg build --pkg-args './source.dhall'
    cabal new-build all
    cabal new-test all
    hlint fast-arithmetic
    yamllint .stylish-haskell.yaml
    yamllint .hlint.yaml
    yamllint .travis.yml
    yamllint appveyor.yml

bench:
    cd fast-arithmetic && bench "cdeps cbits/numerics.c --no-recurse -I .atspkg/contrib/ats-includes-0.3.11/ -I .atspkg/contrib/ats-includes-0.3.11/ccomp/runtime"

dump:
    @cd fast-arithmetic && cdeps cbits/numerics.c --no-recurse -I .atspkg/contrib/ats-includes-0.3.11/ -I .atspkg/contrib/ats-includes-0.3.11/ccomp/runtime
