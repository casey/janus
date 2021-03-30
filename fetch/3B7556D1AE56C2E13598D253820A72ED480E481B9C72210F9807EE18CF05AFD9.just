_: just-fzf

just-fzf:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | fzf)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

fzf-help:
    fzf --help

brew-info-fzf:
    brew info fzf