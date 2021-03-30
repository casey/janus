_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

just-list:
    just --list

choose-gui-help:
    /usr/local/opt/choose-gui/bin/choose -h

choose-gui-brew-info:
    brew info choose-gui