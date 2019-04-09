test:
    atspkg build
    cabal new-test

fresh:
    atspkg build
    cd dhall-ats && atspkg run
    cd aeson-demo && atspkg run
