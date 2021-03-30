_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

ghq-root:
    ghq root

ghq-list:
    ghq list

ghq-list-choose-get-look:
    #!/usr/bin/env sh
    choose_repository=$(ghq list | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Repository : ${choose_repository}"
    ghq get --look "${choose_repository}"

ghq-list-choose-get-update:
    #!/usr/bin/env sh
    choose_repository=$(ghq list | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Repository : ${choose_repository}"
    ghq get --update "${choose_repository}"

ghq-list-full-path:
    ghq list --full-path

ghq-list-unique:
    ghq list --unique

ghq-version:
    ghq --version

ghq-get-huzhenghui-just-awesome:
    ghq get https://github.com/huzhenghui/just-awesome

ghq-get-look-huzhenghui-just-awesome:
    ghq get --look https://github.com/huzhenghui/just-awesome

ghq-get-update-huzhenghui-just-awesome:
    ghq get --update https://github.com/huzhenghui/just-awesome

brew-info-ghq:
    brew info ghq

brew-home-ghq:
    brew home ghq
