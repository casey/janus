generate-cabal:
  nix-shell --pure shell.nix --run "hpack --force"

cabal-repl TARGET:
  nix-shell --pure shell.nix --run "cabal v2-repl {{TARGET}}"

repl TARGET='horrsubs': generate-cabal (cabal-repl TARGET)

build:
  nix-shell --pure shell.nix --run "cabal v2-build"

hoogle:
  nix-shell --pure shell.nix --run "hoogle server"

ghcid:
  nix-shell --pure shell.nix --run "ghcid"